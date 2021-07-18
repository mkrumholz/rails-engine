class Api::V1::MerchantsController < ApplicationController
  def index
    all_merchants = Merchant.all
    merchants = paginate(all_merchants, { page: params[:page], per_page: params[:per_page] })
    formatted_merchants = format_merchant_data(merchants)
    json_response(formatted_merchants)
  end

  def show
    @merchant = Merchant.find(params[:id])
    if @merchant
      formatted = format_merchant_json(@merchant)
      json_response(formatted)
    end
  end
end
