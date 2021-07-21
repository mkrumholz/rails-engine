class Api::V1::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
    list_merchants = paginate(@merchants, { page: params[:page], per_page: params[:per_page] })
    formatted = format_merchant_data(list_merchants)
    json_response(formatted)
  end

  def show
    @merchant = Merchant.find(params[:id])
    formatted = format_merchant_json(@merchant)
    json_response(formatted)
  end

  def find
    return json_response({}, :bad_request) if params[:name].nil? or params[:name] == ''
    @merchant = Merchant.find_first_by_name(params[:name])
    return json_response({}) if @merchant.nil?

    formatted = format_merchant_json(@merchant)
    json_response(formatted)
  end
end
