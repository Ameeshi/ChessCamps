class RegistrationsController < ApplicationController
  authorize_resource
  include AppHelpers::SimpleCart

  def new
    @registration = Registration.new
    @cart_items = get_list_of_registrations_in_cart
  end
  
  def create
      @registration = Registration.new(registration_params)
      if current_user.role?(:parent)
        @cart_items = get_list_of_registrations_in_cart
      end 
      if @registration.save
        flash[:notice] = "Successfully added student."
        redirect_to camp_path(@registration.camp)
      else
        @camp = Camp.find(params[:registration][:camp_id])
        @other_students = @camp.students
        render action: 'new', locals: { camp: @camp, other_students: @other_students }
      end
  end
 
  def destroy
    @registration = Registration.find(params[:id])
    unless @registration.nil?
      @registration.destroy
      flash[:notice] = "Successfully removed this registration."
      redirect_to camp_path(@registration.camp)
    end
  end

  private
    def registration_params
      params.require(:registration).permit(:camp_id, :student_id)
    end

end