module ItemFormatter
  def format_item_data(items)
    items.map { |item| format_json(item) }
  end

  def format_json(item)
    {
      id: item.id,
      type: "item",
      attributes: {
        name: item.name,
        description: item.description,
        unit_price: item.unit_price
      }
    }
  end
end
