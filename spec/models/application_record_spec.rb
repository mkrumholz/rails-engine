require 'rails_helper'

RSpec.describe ApplicationRecord do
  describe 'class methods' do
    describe '.paginated_list' do
      before :each do
        create(:merchant_with_items, items_count: 30)

        merchant = Merchant.first
        @items = merchant.items
      end

      it 'returns a list of objects based on default page and per_page settings' do
        paginated = @items.paginated_list(1, 20)
        expect(paginated).to be_an Array
        expect(paginated.count).to eq 20
        expect(paginated.first).to eq @items.first
        expect(paginated.last).to eq @items[19]
      end

      it 'returns correct objects given non-standard params' do
        paginated = @items.paginated_list(3, 10)

        expect(paginated).to be_an Array
        expect(paginated.count).to eq 10
        expect(paginated.first).to eq @items[20]
        expect(paginated.last).to eq @items[29]
      end

      it 'returns an empty array if params do not specify any objects' do
        paginated = @items.paginated_list(5, 10)

        expect(paginated).to be_an Array
        expect(paginated.count).to eq 0
        expect(paginated).to eq([])
      end
    end
  end
end
