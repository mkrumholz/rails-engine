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

  def create
    @item = Item.create!(item_params)
    formatted = format_json(@item)
    json_response(formatted, :created)
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
