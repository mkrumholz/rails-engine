module ExceptionHandler
  extend ActiveSupport::Concern

  class MissingToken < StandardError; end

  class InvalidToken < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |error|
      json_response({ message: error.message }, :not_found)
    end
  end

  private

  def four_twenty_two(error)
    json_response({ message: error.message }, :unprocessable_entity)
  end
end
