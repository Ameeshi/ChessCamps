class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include AppHelpers::SimpleCart

  # just show a flash message instead of full CanCan exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to take this action. Go away or I shall taunt you a second time."
    redirect_to home_path
  end

  # # handle 404 errors with an exception as well
  # rescue_from ActiveRecord::RecordNotFound do |exception|
  #   flash[:error] = "Seek and you shall find... but not this time"
  #   redirect_to home_path
  # end
  
  private
  # Handling authentication
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def logged_in?
    current_user
  end
  helper_method :logged_in?
  
end
