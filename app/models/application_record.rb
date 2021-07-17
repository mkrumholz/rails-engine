class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.paginate(settings = {})
    settings = defaults if settings.values.all? { |val| val.nil? }
    settings = defaults.merge(settings)
    all.limit(settings[:per_page])
       .offset((settings[:page].to_i - 1) * settings[:per_page])
       .to_a
  end

  def self.defaults
    {page: 1, per_page: 20}
  end
end
