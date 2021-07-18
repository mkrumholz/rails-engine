class Api::V1::ItemsController < ApplicationController
  def index
    @items = Item.all
    list_items = paginate(@items, { page: params[:page], per_page: params[:per_page] })
    formatted_items = format_item_data(list_items)
    json_response(formatted_items)
  end

  def show
    @item = Item.find(params[:id])
    formatted = format_json(@item)
    json_response(formatted)
  end
end
