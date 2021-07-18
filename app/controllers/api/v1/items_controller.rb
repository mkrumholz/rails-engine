class Api::V1::ItemsController < ApplicationController
  def index
    all_items = Item.all
    items = paginate(all_items, { page: params[:page], per_page: params[:per_page] })
    formatted_items = format_item_data(items)
    json_response(formatted_items)
  end
end
