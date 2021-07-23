require 'rails_helper'

RSpec.describe 'weekly revenue report' do
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

    @invoice_1 = create(:invoice, customer: @customer, merchant: @merchant, status: 'shipped', created_at: Time.parse('2021-06-01')) # should be counted
    @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success')
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 10.00) # $50.00
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_2, unit_price: 20.00) # $100.00

    @invoice_2 = create(:invoice, customer: @customer, merchant: @merchant, status: 'pending', created_at: Time.parse('2021-05-01')) # not shipped
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success') 
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_2, item: @item_3, unit_price: 20.00)

    @invoice_3 = create(:invoice, customer: @customer, merchant: @merchant, status: 'shipped', created_at: Time.parse('2021-05-01')) # bad transaction
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'failure')
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_3, item: @item_4, unit_price: 20.00)

    @invoice_4 = create(:invoice, customer: @customer, merchant: @other_merchant, created_at: Time.parse('2021-04-01')) # should be counted
    @transaction_4 = create(:transaction, invoice: @invoice_4)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_4, item: @item_5, unit_price: 20.00) # $100.00

    @invoice_5 = create(:invoice, customer: @customer, merchant: @other_merchant, created_at: Time.parse('2021-01-01')) # should be counted
    @transaction_5 = create(:transaction, invoice: @invoice_5)
    @invoice_item_6 = create(:invoice_item, invoice: @invoice_5, item: @item_6, unit_price: 20.00)
  end

  it 'returns a report of revenue for each week' do
    get '/api/v1/revenue/weekly'

    expect(response).to have_http_status(200)

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:data]).to be_an Array
    expect(result[:data].length).to eq 3

    first_week = result[:data].first
    expect(first_week).to have_key :id
    expect(first_week).to have_key :type
    expect(first_week).to have_key :attributes
    expect(first_week[:attributes][:week]).to eq '2020-12-28'
    expect(first_week[:attributes][:revenue]).to eq 100.00

    last_week = result[:data].last
    expect(last_week[:attributes][:week]).to eq '2021-05-31'
    expect(last_week[:attributes][:revenue]).to eq 150.00
  end
end
