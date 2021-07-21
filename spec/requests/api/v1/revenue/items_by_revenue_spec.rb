require 'rails_helper'

RSpec.describe 'Items by revenue' do
  context 'no quantity is specified' do
    it 'returns the top 10 items by revenue generated' do
      customer = create(:customer)
      create_list(:merchant, 3) do |merchant| 
        create_list(:item, 5, merchant: merchant) do |item|
          invoice = create(:invoice, customer: customer, merchant: merchant)
          create(:invoice_item, invoice: invoice, item: item)
          create(:transaction, invoice: invoice)
        end
      end
      require 'pry'; binding.pry

    end
  end

  context 'quantity is specified and less than 1 or not an integer' do
    it 'returns an error message and 400 status code' do
      
    end
  end
end
