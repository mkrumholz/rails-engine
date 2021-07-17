class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.paginated_list(page, per_page)
    all.limit(per_page)
       .offset((page - 1) * per_page)
       .to_a
  end
end
