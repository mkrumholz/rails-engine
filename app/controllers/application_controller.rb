class ApplicationController < ActionController::API
  include ItemFormatter
  include Response
  include Paginator
end
