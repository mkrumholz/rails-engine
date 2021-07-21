class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices

  def self.find_first_by_name(query)
    find_by_sql(['select * from merchants where name ilike ? order by lower(name) asc limit 1;', "%#{query}%"]).first
  end
end
