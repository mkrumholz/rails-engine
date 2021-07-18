module Paginator
  def paginate(objects, settings = {})
    settings = settings.delete_if { |_key, val| val.nil? }.to_h
    settings = defaults.merge(settings)
    page = settings[:page].to_i
    per_page = settings[:per_page].to_i
    objects.paginated_list(page, per_page)
  end

  def defaults
    { page: 1, per_page: 20 }
  end
end
