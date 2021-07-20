require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
  end

  describe 'class methods' do
    describe 'find_first_by_name' do
      it 'returns the 1st name matching the search in case insens alph order' do
        merchant_1 = create(:merchant, name: 'Mortimer\'s Mysteries')
        merchant_2 = create(:merchant, name: 'Illy')
        merchant_3 = create(:merchant, name: 'Iliad Ventures')
        merchant_4 = create(:merchant, name: 'The Tilt')
        merchant_5 = create(:merchant, name: 'nilla\'s wafers')

        expect(Merchant.find_first_by_name('iLl')).to eq merchant_2
      end

      it 'returns an empty array if no matches are available' do
        merchant_2 = create(:merchant, name: 'Iliad Ventures')
        merchant_3 = create(:merchant, name: 'The Tilt')
        merchant_4 = create(:merchant, name: 'Mortimer\'s Mysteries')
          
        expect(Merchant.find_first_by_name('iLl')).to be_nil
      end
    end
  end
end
