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
      
      get '/api/v1/revenue/items'

      expect(response).to have_http_status(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data]).to be_an Array
      expect(result[:data].length).to eq 10

      top_item = result[:data].first
      expect(top_item).to have_key :id  
      expect(top_item[:type]).to eq 'item'    
      expect(top_item[:attributes]).to be_a Hash

      expect(top_item[:attributes]).to have_key :name
      expect(top_item[:attributes]).to have_key :description
      expect(top_item[:attributes]).to have_key :unit_price
      expect(top_item[:attributes]).to have_key :merchant_id
      expect(top_item[:attributes]).to have_key :revenue

      second_item = result[:data].second
      first_revenue = top_item[:attributes][:revenue]
      second_revenue = second_item[:attributes][:revenue]
      expect(first_revenue > second_revenue).to be true
    end
  end

  context 'quantity is specified and valid' do
    it 'returns the specified # of items ordered by revenue generated desc' do
      customer = create(:customer)
      create_list(:merchant, 3) do |merchant| 
        create_list(:item, 5, merchant: merchant) do |item|
          invoice = create(:invoice, customer: customer, merchant: merchant)
          create(:invoice_item, invoice: invoice, item: item)
          create(:transaction, invoice: invoice)
        end
      end
      
      get '/api/v1/revenue/items', params: {quantity: 4}

      expect(response).to have_http_status(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data]).to be_an Array
      expect(result[:data].length).to eq 4

      top_item = result[:data].first
      second_item = result[:data].second
      first_revenue = top_item[:attributes][:revenue]
      second_revenue = second_item[:attributes][:revenue]
      expect(first_revenue > second_revenue).to be true
    end
  end

  context 'quantity is specified and invalid' do
    it 'negative int returns an error message and 400 status code' do
      get '/api/v1/revenue/items', params: {quantity: -2}

      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end

    it 'string returns an error message and 400 status code' do
      get '/api/v1/revenue/items', params: {quantity: 'string'}

      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end
end
