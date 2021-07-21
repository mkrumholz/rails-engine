class Api::V1::Merchants::SearchController < ApplicationController
  def find
    return json_response({ data: {} }, :bad_request) unless valid_search?(params)

    @merchant = Merchant.find_first_by_name(params[:name])
    return json_response({ data: {} }) if @merchant.nil?

    json_response(MerchantSerializer.new(@merchant))
  end

  private

  def valid_search?(params)
    params[:name].present?
  end
end
