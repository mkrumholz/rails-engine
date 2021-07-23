require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoices).dependent(:nullify) }
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

  describe 'instance methods' do
    before :each do
      @customer = create(:customer)
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      
      # merchant 1 
      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_1)
      @item_3 = create(:item, merchant: @merchant_1)
      @item_4 = create(:item, merchant: @merchant_1)
  
      @invoice_1 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'shipped') # should be counted
      @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success')
      @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 10.00) # $50.00
      @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_2, unit_price: 20.00) # $100.00
  
      @invoice_2 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'pending') # not shipped
      @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success') 
      @invoice_item_3 = create(:invoice_item, invoice: @invoice_2, item: @item_3, unit_price: 20.00)
  
      @invoice_3 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'shipped') # bad transaction
      @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'failure')
      @invoice_item_4 = create(:invoice_item, invoice: @invoice_3, item: @item_4, unit_price: 20.00)
  
      # merchant 2
      @item_5 = create(:item, merchant: @merchant_2)
      @item_6 = create(:item, merchant: @merchant_2)
  
      @invoice_4 = create(:invoice, customer: @customer, merchant: @merchant_2)
      @transaction_4 = create(:transaction, invoice: @invoice_4)
      @invoice_item_5 = create(:invoice_item, invoice: @invoice_4, item: @item_5, unit_price: 20.00) # $100.00
  
      @invoice_5 = create(:invoice, customer: @customer, merchant: @merchant_2)
      @transaction_5 = create(:transaction, invoice: @invoice_5)
      @invoice_item_6 = create(:invoice_item, invoice: @invoice_5, item: @item_6, unit_price: 20.00) # $100.00
    end
    
    describe 'total_revenue' do
      it 'returns the total revenue for the merchant' do
        expect(@merchant_2.total_revenue.revenue).to eq 200.00
      end

      it 'does not count revenue from invoices that are not shipped or that do not have good transactions' do
        expect(@merchant_1.total_revenue.revenue).to eq 150.00
      end
    end
  end
end
