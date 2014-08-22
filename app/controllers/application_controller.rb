class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  private

  def current_user
  	@current_user ||= WebUser.find_by_oauth_token!(cookies[:oauth_token]) if cookies[:oauth_token]
  end
  helper_method :current_user
end
