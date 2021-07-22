class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  has_many :transactions, dependent: :nullify
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def self.revenue_for_range(start_date, end_date)
    # end_date = (Date.parse(end_date) + 1).to_s
    joins(:transactions)
    .joins(:invoice_items)
    .where(transactions: { result: 'success' })
    .where(invoices: { status: 'shipped' })
    .where("invoices.created_at between ? and date(?) + interval '1 day'", start_date, end_date)
    # .where("?::tsrange @> invoices.created_at", "[#{start_date}, #{end_date})")
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
