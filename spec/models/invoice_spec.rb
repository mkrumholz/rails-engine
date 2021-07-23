require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it {should belong_to :customer}
    it {should belong_to :merchant}
    it {should have_many(:transactions).dependent(:nullify) }
    it {should have_many(:invoice_items).dependent(:destroy) }
    it {should have_many(:items).through(:invoice_items) }
  end

  describe 'class methods' do
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

      @invoice_4 = create(:invoice, customer: @customer, merchant: @other_merchant, created_at: Time.parse('2021-04-01')) # should be counted and in date range
      @transaction_4 = create(:transaction, invoice: @invoice_4)
      @invoice_item_5 = create(:invoice_item, invoice: @invoice_4, item: @item_5, unit_price: 20.00) # $100.00
  
      @invoice_5 = create(:invoice, customer: @customer, merchant: @other_merchant, created_at: Time.parse('2021-01-01')) # good invoice, but not in date range
      @transaction_5 = create(:transaction, invoice: @invoice_5)
      @invoice_item_6 = create(:invoice_item, invoice: @invoice_5, item: @item_6, unit_price: 20.00)
    end

    describe 'revenue_for_range' do
      it 'returns the total revenue for the given range, inclusive of both dates' do
        start_date = '2021-04-01'
        end_date = '2021-06-01'

        expect(Invoice.revenue_for_range(start_date, end_date)).to eq 250.00
      end
      
      it 'does not include revenue for unshipped invoices' do
        invoice_2 = create(:invoice, customer: @customer, merchant: @merchant, status: 'pending', created_at: Time.parse('2021-05-01')) # not shipped
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success') 
        invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: @item_3, unit_price: 20.00)
    
        start_date = '2021-04-20'
        end_date = '2021-05-20'

        expect(Invoice.revenue_for_range(start_date, end_date)).to eq 0.00
      end

      it 'does not include revenue for invoices without a good transaction' do
        invoice_3 = create(:invoice, customer: @customer, merchant: @merchant, status: 'shipped', created_at: Time.parse('2021-05-01')) # bad transaction
        transaction_3 = create(:transaction, invoice: invoice_3, result: 'failure')
        invoice_item_4 = create(:invoice_item, invoice: invoice_3, item: @item_4, unit_price: 20.00)

        start_date = '2021-04-20'
        end_date = '2021-05-20'

        expect(Invoice.revenue_for_range(start_date, end_date)).to eq 0.00
      end
    end

    describe 'revenue_by_week' do
      it 'returns a list of revenue by week' do
        report = Invoice.revenue_by_week

        expect(report).to be_an Array
        expect(report.length).to eq 3
        expect(report.first.week.to_s).to eq '2020-12-28'
        expect(report.first.revenue).to eq 100.00
        expect(report.last.week.to_s).to eq '2021-05-31'
        expect(report.last.revenue).to eq 150.00
      end
    end
  end
end
