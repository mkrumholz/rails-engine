class ApplicationController < ActionController::API
  include ExceptionHandler
  include Paginator
  include Response
end
