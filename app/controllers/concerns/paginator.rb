module Paginator
  def paginate(objects, settings = {})
    settings = validate_preferences(settings)
    page = settings[:page].to_i
    per_page = settings[:per_page].to_i
    objects.paginated_list(page, per_page)
  end

  def validate_preferences(settings)
    settings.delete_if { |_key, val| val.nil? || val.to_i < 1 }.to_h
    defaults.merge(settings)
  end

  def defaults
    { page: 1, per_page: 20 }
  end
end
