class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]

  def index
    @instructors = Instructor.all.alphabetical.paginate(:page => params[:page]).per_page(12)
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
    if @instructor.save
      redirect_to instructor_path(@instructor), notice: "#{@instructor.first_name} #{@instructor.last_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @instructor.update(instructor_params)
      redirect_to instructor_path(@instructor), notice: "#{@instructor.first_name} #{@instructor.last_name} was revised in the system."
    else
      render action: 'edit'
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

    def instructor_params
      params.require(:instructor).permit(:first_name, :last_name, :bio, :user_id, :email, :phone, :active)
    end
end