class ApplicationController < ActionController::API
  include ItemFormatter
  include MerchantFormatter
  include Response
  include Paginator
end
