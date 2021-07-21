class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, :description, :unit_price, presence: true
  validates :unit_price, numericality: { greater_than: 0.0 }

  def self.search_by_name(query)
    where('name ilike ? or description ilike ?', "%#{query}%", "%#{query}%")
    .order('lower(name) asc').to_a
  end
end
