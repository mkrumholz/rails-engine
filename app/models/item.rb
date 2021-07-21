class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, :description, :unit_price, presence: true
  validates :unit_price, numericality: { greater_than: 0.0 }

  def self.search_by_name(query)
    where('name ilike ? or description ilike ?', "%#{query}%", "%#{query}%")
      .order(Arel.sql('lower(name) asc')).to_a
  end

  def self.search_by_price(search_details)
    min = search_details[:min_price]
    max = search_details[:max_price]
    if min && max
      where('unit_price > ?', min).where('unit_price < ?', max).to_a
    elsif max
      where('unit_price < ?', max).to_a
    elsif min
      where('unit_price > ?', min).to_a
    end
  end
end
