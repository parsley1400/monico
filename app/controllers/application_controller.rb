class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :null_session
  before_action :require_sign_in!
end
