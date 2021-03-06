class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    params[:quantity] = 10 if params[:quantity].nil?
    return json_response({ error: 'Bad request' }, :bad_request) unless quantity_valid?(params[:quantity].to_i)

    @items = Item.order_by_revenue(params[:quantity])
    json_response(ItemSerializer.new(@items))
  end

  private

  def quantity_valid?(quantity)
    quantity.is_a?(Integer) && quantity >= 1 && quantity <= 1_000_000
  end
end
