module ItemFormatter
  def format_item_data(items)
    items.map { |item| format_json(item) }
  end

  def format_json(item)
    {
      id: item.id.to_s,
      type: 'item',
      attributes: {
        name: item.name,
        description: item.description,
        unit_price: item.unit_price,
        merchant_id: item.merchant_id
      }
    }
  end
end
