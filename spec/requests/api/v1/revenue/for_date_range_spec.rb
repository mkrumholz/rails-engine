require 'rails_helper'

RSpec.describe 'requests for date range' do
  before :each do
    @customer = create(:customer)
    @merchant = create(:merchant)
    @other_merchant = create(:merchant)

    @item_1 = create(:item, merchant: @merchant)
    @item_2 = create(:item, merchant: @merchant)
    @item_3 = create(:item, merchant: @merchant)
    @item_4 = create(:item, merchant: @merchant)
    @item_5 = create(:item, merchant: @other_merchant)
    @item_6 = create(:item, merchant: @other_merchant)

    @invoice_1 = create(:invoice, customer: @customer, merchant: @merchant, status: 'shipped', created_at: Time.parse('2021-06-01')) # should be counted and in date range
    @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success')
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 10.00) # $50.00
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_2, unit_price: 20.00) # $100.00

    @invoice_2 = create(:invoice, customer: @customer, merchant: @merchant, status: 'pending', created_at: Time.parse('2021-05-01')) # not shipped
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success') 
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_2, item: @item_3, unit_price: 20.00)

    @invoice_3 = create(:invoice, customer: @customer, merchant: @merchant, status: 'shipped', created_at: Time.parse('2021-05-01')) # bad transaction
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'failure')
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_3, item: @item_4, unit_price: 20.00)

    @invoice_4 = create(:invoice, customer: @customer, merchant: @other_merchant, created_at: Time.parse('2021-04-01')) # should be counted and in date range
    @transaction_4 = create(:transaction, invoice: @invoice_4)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_4, item: @item_5, unit_price: 20.00) # $100.00

    @invoice_5 = create(:invoice, customer: @customer, merchant: @other_merchant, created_at: Time.parse('2021-01-01')) # good invoice, but not in date range
    @transaction_5 = create(:transaction, invoice: @invoice_5)
    @invoice_item_6 = create(:invoice_item, invoice: @invoice_5, item: @item_6, unit_price: 20.00)
  end

  context 'both dates are present and valid' do
    it 'returns a revenue object showing the total for that range (inclusive)' do
      get '/api/v1/revenue', params: {start_date: '2021-04-01', end_date: '2021-06-01'}

      expect(response).to have_http_status(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data]).to be_a Hash
      expect(result[:data]).to have_key :id
      expect(result[:data]).to have_key :attributes

      expect(result[:data][:attributes][:revenue]).to eq 250.00
    end
  end

  context 'start date is missing' do
    it 'returns an error message and 400 status code' do
      get '/api/v1/revenue', params: {end_date: '2021-06-01'}
      
      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end

  context 'end date is missing' do
    it 'returns an error message and 400 status code' do
      get '/api/v1/revenue', params: {start_date: '2021-04-01'}
      
      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end

  context 'both dates are missing' do
    it 'returns an error message and 400 status code' do
      get '/api/v1/revenue'
      
      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end

  context 'date format is not valid' do
    it 'returns an error message and 400 status code' do
      get '/api/v1/revenue', params: {start_date: 'string', end_date: ''}
      
      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end

  context 'end date is before start date' do
    it 'returns an error message and 400 status code' do
      get '/api/v1/revenue', params: {start_date: '2021-06-01', end_date: '2021-04-01'}
      
      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end
end
