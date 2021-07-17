require 'rails_helper'

RSpec.describe ApplicationRecord do
  describe 'class methods' do
    describe '.paginate' do
      it 'returns a list of objects based on default pagination params' do
        create(:merchant_with_items, items_count: 30)

        merchant = Merchant.first
        items = merchant.items

        expect(items.paginate).to be_an Array
        expect(items.paginate.count).to eq 20
        expect(items.paginate.first).to eq items.first
        expect(items.paginate.last).to eq items[19]
      end

      # it 'returns a list of objects based on input of given pagination params (both)' do

      # end
    end
  end
end