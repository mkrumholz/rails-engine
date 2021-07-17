require 'rails_helper'

RSpec.describe ApplicationRecord do
  describe 'class methods' do
    describe '.paginate' do
      before :each do
        create(:merchant_with_items, items_count: 30)

        merchant = Merchant.first
        @items = merchant.items
      end

      it 'returns a list of objects based on default pagination params' do
        paginated = @items.paginate
        expect(paginated).to be_an Array
        expect(paginated.count).to eq 20
        expect(paginated.first).to eq @items.first
        expect(paginated.last).to eq @items[19]
      end

      it 'returns a list of objects given pagination params (both)' do
        paginated = @items.paginate({page: 3, per_page: 10})

        expect(paginated).to be_an Array
        expect(paginated.count).to eq 10
        expect(paginated.first).to eq @items[20]
        expect(paginated.last).to eq @items[29]
      end

      it 'returns a list of objects given page num only (default 20 per page)' do
        paginated = @items.paginate({page: 2})

        expect(paginated).to be_an Array
        expect(paginated.count).to eq 10
        expect(paginated.first).to eq @items[20]
        expect(paginated.last).to eq @items.last
      end

      it 'returns a list of objects given per_page only (default to first page)' do
        paginated = @items.paginate({per_page: 10})

        expect(paginated).to be_an Array
        expect(paginated.count).to eq 10
        expect(paginated.first).to eq @items.first
        expect(paginated.last).to eq @items[9]
      end
    end
  end
end
