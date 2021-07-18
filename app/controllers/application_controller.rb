class ApplicationController < ActionController::API
  include ExceptionHandler
  include ItemFormatter
  include MerchantFormatter
  include Paginator
  include Response
end
