class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    @instructors = Instructor.all.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @past_camps = @instructor.camps.past.chronological
    @upcoming_camps = @instructor.camps.upcoming.chronological
  end

  def edit
  end

  def new
    @instructor = Instructor.new
  end

  def create
    @instructor = Instructor.new(instructor_params)
    @user = User.new(user_params)
    @user.role = "instructor"
    if !@user.save
      @instructor.valid?
      render action: 'new'
    else
      @instructor.user_id = @user.id
      if @instructor.save
        flash[:notice] = "Successfully created #{@instructor.first_name} #{@instructor.last_name}."
        redirect_to instructor_path(@instructor) 
      else
        render action: 'new'
      end      
    end
  end

  def update
    if logged_in? and current_user.role?(:admin)
      if @instructor.update(instructor_params) and @instructor.user.update(user_params)
        redirect_to instructor_path(@instructor), notice: "#{@instructor.first_name} #{@instructor.last_name} was revised in the system."
      else
        render action: 'edit'
      end
    elsif logged_in? and current_user.role?(:instructor)
      if @instructor.update(instructor2_params) and @instructor.user.update(iuser_params)
        redirect_to instructor_path(@instructor), notice: "#{@instructor.first_name} #{@instructor.last_name} was revised in the system."
      else
        render action: 'edit'
      end
    end
  end

  def destroy
    @instructor.destroy
    redirect_to instructors_url, notice: "#{@instructor.first_name} #{@instructor.last_name} was deleted from the system."
  end

  private
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    def user_params
      params.require(:instructor).permit(:username, :email, :phone, :password, :password_confirmation, :active)
    end

    def instructor_params
      params.require(:instructor).permit(:first_name, :last_name, :bio, :photo, :active)
    end

    def iuser_params
      params.require(:instructor).permit(:email, :phone, :password, :password_confirmation)
    end

    def instructor2_params
      params.require(:instructor).permit(:bio, :photo)
    end
end