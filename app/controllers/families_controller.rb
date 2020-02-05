class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    if current_user.role?(:instructor)
      @families = current_user.instructor.families.alphabetical.paginate(:page => params[:families]).per_page(10)
    elsif current_user.role?(:admin)
      @families = Family.all.alphabetical.paginate(:page => params[:families]).per_page(10)
    end
  end

  def show
    @students = @family.students.alphabetical
  end

  def edit
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    @user = User.new(user_params)
    @user.role = "parent"
    if !@user.save
      @family.valid?
      render action: 'new'
    else
      @family.user_id = @user.id
      if @family.save
        if current_user.nil?
          session[:user_id] = @user.id
          flash[:notice] = "Successfully created #{@family.family_name} account."
          redirect_to home_path 
        else
          flash[:notice] = "Successfully created #{@family.proper_name}."
          redirect_to family_path(@family)
        end
      else
        render action: 'new'
      end      
    end
  end

  def update
    if !current_user.nil? and current_user.role?(:admin)
      if @family.update(family_params) and @family.user.update(user_params)
        redirect_to family_path(@family), notice: "#{@family.family_name} was revised in the system."
      else
        render action: 'edit'
      end
    elsif !current_user.nil? and current_user.role?(:parent)
      if @family.user.update(editing_params)
        redirect_to family_path(@family), notice: "#{@family.family_name} was revised in the system."
      else
        render action: 'edit'
      end
    end
  end

  def destroy
    @family.destroy
    redirect_to families_url, notice: "#{@family.family_name} was deleted from the system."
  end

  private
    def set_family
      @family = Family.find(params[:id])
    end

    def family_params
      params.require(:family).permit(:family_name, :parent_first_name, :user_id, :active)
    end

    def user_params
      params.require(:family).permit(:username, :email, :phone, :password, :password_confirmation, :active)
    end

    def editing_params
      params.require(:family).permit(:email, :phone, :password, :password_confirmation)
    end
end