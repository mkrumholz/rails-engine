module MerchantFormatter
  def format_merchant_data(merchants)
    merchants.map { |merchant| format_merchant_json(merchant) }
  end

  def format_merchant_json(merchant)
    {
      id: merchant.id.to_s,
      type: "merchant",
      attributes: {
        name: merchant.name
      }
    }
  end
end
