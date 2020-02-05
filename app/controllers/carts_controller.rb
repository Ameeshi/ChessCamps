class CartsController < ApplicationController
  
  include AppHelpers::SimpleCart
  
  def create 
    session[:cart].each do |cart|
      @registrations_new = Registration.new(cart_params)
      @registrations_new.camp_id = cart[0]
      @registrations_new.student_id = cart[1]
      @registrations_new.credit_card_number = params[:registration][:credit_card_number]
      @registrations_new.expiration_year = params[:registration][:expiration_year].to_i
      @registrations_new.expiration_month = params[:registration][:expiration_month]
      if @registrations_new.valid?
        @registrations_new.pay
        @registrations_new.save
      else 
        flash[:notice] = "There are problems in the cart"
      end
    end 
    clear_cart
    redirect_to home_path
  end 


  def index
  end

  def show
    unless @registration.payment.nil?
      info = Base64.decode64(@registration.payment)[-13..-1]
      type = info[0..3]
      card_num = info[-8..-1]
      if type[0] == ":"
        type = info[2..3]
      end
      @payment_info = type + " " + card_num
    end
  end

  def new
    @registration = Registration.new
    @cart_items = get_list_of_registrations_in_cart
  end

  def edit
    @cart = Cart.find(params[:id])
  end

  def add_to_cart 
    add_registration_to_cart(cart_params[:camp_id], cart_params[:student_id])
    @camp = Camp.find(cart_params[:camp_id])
    redirect_to camp_path(@camp)
    flash[:notice] = "Added registration to the cart"
  end 

  def delete_from_cart
    remove_registration_from_cart(params[:camp_id], params[:student_id])
    flash[:notice] = "Removed registration from the cart."
    redirect_to view_cart_path
  end 

  private
    def cart_params
      params.require(:registration).permit(:camp_id, :student_id, :credit_card_number, :expiration_year, :expiration_month)
    end
end