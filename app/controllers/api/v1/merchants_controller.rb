class Api::V1::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
    list_merchants = paginate(@merchants, { page: params[:page], per_page: params[:per_page] })
    json_response(MerchantSerializer.new(list_merchants))
  end

  def show
    @merchant = Merchant.find(params[:id])
    json_response(MerchantSerializer.new(@merchant))
  end
end
