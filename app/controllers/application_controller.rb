class ApplicationController < ActionController::API
  include ExceptionHandler
  include MerchantFormatter
  include Paginator
  include Response
end
