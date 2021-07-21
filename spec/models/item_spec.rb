require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it {should have_many :invoice_items }
    it {should have_many(:invoices).through(:invoice_items) }
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

  describe 'search_by_price' do
    context 'when both params are present' do
      it 'returns a list of matching items by price' do
        merchant_1 = create(:merchant, name: 'Rings and Things')
        merchant_2 = create(:merchant, name: 'Book Nook')

        # should show up in results
        item_1 = create(:item, unit_price: 140.00, merchant: merchant_1)
        item_2 = create(:item, unit_price: 100.00, merchant: merchant_1)
        item_3 = create(:item, unit_price: 75.00, merchant: merchant_2)

        # should not show up in results
        item_4 = create(:item, unit_price: 40.00, merchant: merchant_2) 

        price_params = { min_price: 70, max_price: 160 }

        expect(Item.search_by_price(price_params)).to be_an Array
        expect(Item.search_by_price(price_params).length).to eq 3

        expect(Item.search_by_price(price_params)).not_to include item_4
      end
    end
    
    context 'when only min_price is given' do
      it 'returns a list of items with higher prices than given param' do
        merchant_1 = create(:merchant, name: 'Rings and Things')
        merchant_2 = create(:merchant, name: 'Book Nook')

        # should show up in results
        item_1 = create(:item, unit_price: 140.00, merchant: merchant_1)
        item_2 = create(:item, unit_price: 100.00, merchant: merchant_1)
        item_3 = create(:item, unit_price: 75.00, merchant: merchant_2)

        # should not show up in results
        item_4 = create(:item, unit_price: 40.00, merchant: merchant_2) 

        price_params = { min_price: 70, max_price: nil }

        expect(Item.search_by_price(price_params)).to be_an Array
        expect(Item.search_by_price(price_params).length).to eq 3

        expect(Item.search_by_price(price_params)).not_to include item_4
      end
    end

    context 'when only max_price is given' do
      it 'returns a list of lower prices than given param' do
        merchant_1 = create(:merchant, name: 'Rings and Things')
        merchant_2 = create(:merchant, name: 'Book Nook')

        # should show up in results
        item_1 = create(:item, unit_price: 140.00, merchant: merchant_1)
        item_2 = create(:item, unit_price: 100.00, merchant: merchant_1)
        item_3 = create(:item, unit_price: 75.00, merchant: merchant_2)

        # should not show up in results
        item_4 = create(:item, unit_price: 170.00, merchant: merchant_2) 

        price_params = { min_price: nil, max_price: 160 }

        expect(Item.search_by_price(price_params)).to be_an Array
        expect(Item.search_by_price(price_params).length).to eq 3

        expect(Item.search_by_price(price_params)).not_to include item_4
      end
    end

    it 'returns an empty array if no matching items are found' do
      merchant_1 = create(:merchant, name: 'Rings and Things')
      merchant_2 = create(:merchant, name: 'Book Nook')

      expect(Item.search_by_name('ring')).to be_an Array
      expect(Item.search_by_name('ring')).to be_empty
    end
  end

  describe 'order_by_revenue' do
    it 'returns a list of items by revenue generated' do
      customer = create(:customer)
      create_list(:merchant, 3) do |merchant| 
        create_list(:item, 5, merchant: merchant) do |item|
          invoice = create(:invoice, customer: customer, merchant: merchant)
          create(:invoice_item, invoice: invoice, item: item)
          create(:transaction, invoice: invoice)
        end
      end

      actual = Item.order_by_revenue(3)
      expect(actual).to be_an Array
      expect(actual.length).to eq 3
      expect(actual.first.revenue > actual.second.revenue).to be true
    end

    it 'only counts revenue from successful transactions with shipped invoices' do
      customer = create(:customer)
      merchant = create(:merchant)

      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      item_3 = create(:item, merchant: merchant)
      item_4 = create(:item, merchant: merchant)

      invoice_1 = create(:invoice, customer: customer, merchant: merchant, status: 'shipped') # shipped and good transaction
      transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 10.00)
      invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_2, unit_price: 20.00)

      invoice_2 = create(:invoice, customer: customer, merchant: merchant, status: 'pending') # not shipped
      transaction_2 = create(:transaction, invoice: invoice_2, result: 'success') 
      invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_3, unit_price: 20.00)

      invoice_3 = create(:invoice, customer: customer, merchant: merchant, status: 'shipped') # bad transaction
      transaction_3 = create(:transaction, invoice: invoice_3, result: 'failure')
      invoice_item_4 = create(:invoice_item, invoice: invoice_3, item: item_4, unit_price: 20.00)
      
      actual = Item.order_by_revenue(4)
      expect(actual).to be_an Array
      expect(actual.length).to eq 2
      expect(actual.first).to eq item_2
      expect(actual.second).to eq item_1
      expect(actual.first.revenue > actual.second.revenue).to be true

      expect(actual).not_to include item_3
      expect(actual).not_to include item_4
    end
  end
end
