class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
    @items = @merchant.items.all
    formatted_items = format_item_data(@items)
    json_response(formatted_items)
  end
end
