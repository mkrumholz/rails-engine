class Api::V1::RevenueController < ApplicationController
  def show
    return json_response({ errors: 'Bad request' }, :bad_request) unless range_valid?(params)
    require 'pry'; binding.pry
    @revenue = Invoice.revenue_for_range(params[:start_date], params[:end_date])
    json_response(RevenueSerializer.new(@revenue))
  end

  private

  def range_valid?(params)
    start_date = date_valid?(params[:start_date])
    end_date = date_valid?(params[:end_date])
    start_date && end_date && start_date < end_date
  end

  def date_valid?(date)
    Date.strptime(date,"%Y-%m-%d") rescue false
  end
end
