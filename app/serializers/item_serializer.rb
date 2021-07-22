class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant_id
  attributes :revenue, if: Proc.new {|item|
    item.revenue.present?
  }
end
