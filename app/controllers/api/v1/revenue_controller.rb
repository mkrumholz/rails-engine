class Api::V1::RevenueController < ApplicationController
  def show
    return json_response({ error: 'Bad request' }, :bad_request) unless range_valid?(params)
    @revenue = Invoice.revenue_for_range(params[:start], params[:end])
    json_response(RevenueSerializer.format_json(@revenue))
  end

  private

  def range_valid?(params)
    start_date = date_valid?(params[:start])
    end_date = date_valid?(params[:end])
    start_date && end_date && start_date < end_date
  end

  def date_valid?(date)
    Date.strptime(date,"%Y-%m-%d") rescue false
  end
end
