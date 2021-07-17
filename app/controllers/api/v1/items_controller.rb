class Api::V1::ItemsController < ApplicationController
  def index
    defaults = {page: 1, per_page: 20}
    items = Item.all.paginate({ page: params[:page], per_page: params[:per_page]}.merge(defaults))
    # items = Item.all
    formatted_items = format_item_data(items)
    json_response(formatted_items)
  end
end
