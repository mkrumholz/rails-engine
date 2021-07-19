class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]

  def index
    @items = Item.all
    list_items = paginate(@items, { page: params[:page], per_page: params[:per_page] })
    formatted_items = format_item_data(list_items)
    json_response(formatted_items)
  end

  def show
    formatted = format_json(@item)
    json_response(formatted)
  end

  def create
    @item = Item.create!(item_params)
    formatted = format_json(@item)
    json_response(formatted, :created)
  end

  def update
    @item.update!(item_params)
    formatted = format_json(@item)
    json_response(formatted, :accepted)
  end

  def destroy
    @item.destroy
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
