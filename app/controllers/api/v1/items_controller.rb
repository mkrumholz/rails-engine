class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all.paginate({ page: params[:page], per_page: params[:per_page]})
    formatted_items = format_item_data(items)
    json_response(formatted_items)
  end
end
