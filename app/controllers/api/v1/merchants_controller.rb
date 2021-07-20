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
    @merchant = Merchant.find_by_sql("select * from merchants where name ilike '%#{params[:name]}%' order by lower(name) asc limit 1;").first
    return json_response('') if @merchant.nil?
    formatted = format_merchant_json(@merchant)
    json_response(formatted)
  end
end
