class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy

  def self.find_first_by_name(name)
    find_by_sql("select * from merchants where name ilike '%#{name}%' order by lower(name) asc limit 1;").first
    # where("name ilike '%#{name}%'")
    # .order('lower(name)')
    # .limit(1).first
  end
end
