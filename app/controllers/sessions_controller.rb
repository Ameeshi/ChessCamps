class SessionsController < ApplicationController
  include AppHelpers::SimpleCart

  def new
  end
  
  def create
    user = User.find_by_username(params[:username])
    if user && User.authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      if user.role?(:parent)
        create_cart
      end
      redirect_to home_path, notice: "Logged in!"
    else
      flash.now.alert = "Username and/or password is invalid"
      render "new"
    end
  end
  
  def destroy
    if current_user.role?(:parent)
      destroy_cart
    end
    session[:user_id] = nil
    redirect_to home_path, notice: "Logged out!"
  end
end



