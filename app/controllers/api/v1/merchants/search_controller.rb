class Api::V1::Merchants::SearchController < ApplicationController
  def find
    return json_response({}, :bad_request) if params[:name].nil? or params[:name] == ''
    @merchant = Merchant.find_first_by_name(params[:name])
    return json_response({}) if @merchant.nil?
  
    formatted = format_merchant_json(@merchant)
    json_response(formatted)
  end
end
