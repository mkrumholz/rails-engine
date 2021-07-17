class Api::V1::ItemsController < ApplicationController
  def index
    render json: {data: Item.all}
  end
end
