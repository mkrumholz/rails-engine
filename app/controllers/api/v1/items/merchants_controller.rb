class Api::V1::Items::MerchantsController < ApplicationController
  def index
    @item = Item.find(params[:id])
    @merchant = Merchant.find(@item.merchant_id)
    formatted = format_merchant_json(@merchant)
    json_response(formatted)
  end
end
