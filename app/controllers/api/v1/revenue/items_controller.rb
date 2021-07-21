class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    return json_response({errors: 'Bad request'}, :bad_request) if !quantity_valid?(params[:quantity])
    @items = Item.order_by_revenue(params[:quantity])
    json_response(ItemSerializer.new(@items))
  end

  private

  def quantity_valid?(quantity)
    quantity.nil? || (quantity.is_a?(Integer) && quantity >= 1 && quantity <= 1000)
  end
end
