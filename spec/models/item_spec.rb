require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :unit_price}
    it {should validate_numericality_of(:unit_price).is_greater_than(0.0)}
  end

  describe 'search_by_name' do
    it 'returns a list of matching items by name and/or description' do
      merchant_1 = create(:merchant, name: 'Rings and Things')
      merchant_2 = create(:merchant, name: 'Book Nook')

      # should show up in results
      item_1 = create(:item, name: 'Gourd of the Rings', merchant: merchant_1)
      item_2 = create(:item, name: 'beetle beets', description: 'ringourd star', merchant: merchant_1)
      item_3 = create(:item, name: 'Poor Moorings', merchant: merchant_2)

      # should not show up in results
      item_4 = create(:item, name: 'Loom of Doom', description: 'Your worst loom nightmare', merchant: merchant_2) 

      expect(Item.search_by_name('ring')).to be_an Array
      expect(Item.search_by_name('ring').length).to eq 3

      expect(Item.search_by_name('ring').first).to eq item_2
      expect(Item.search_by_name('ring').second).to eq item_1
      expect(Item.search_by_name('ring').last).to eq item_3

      expect(Item.search_by_name('ring')).not_to include item_4
    end

    it 'returns an empty array if no matching items are found' do
      merchant_1 = create(:merchant, name: 'Rings and Things')
      merchant_2 = create(:merchant, name: 'Book Nook')

      expect(Item.search_by_name('ring')).to be_an Array
      expect(Item.search_by_name('ring')).to be_empty
    end
  end
end
