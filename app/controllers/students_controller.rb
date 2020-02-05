class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    if current_user.role?(:instructor)
      @students = current_user.instructor.students.alphabetical.paginate(:page => params[:students]).per_page(10)
    elsif current_user.role?(:parent)
      @students = current_user.family.students.alphabetical.paginate(:page => params[:students]).per_page(10)
    elsif current_user.role?(:admin)
      @students = Student.all.alphabetical.paginate(:page => params[:students]).per_page(10)
    end
  end

  def show
    @family = @student.family
    @past_camps = @student.camps.past.chronological
    @upcoming_camps = @student.camps.upcoming.chronological
  end

  def edit
  end

  def new
    @student = Student.new
  end

  def create
    if logged_in? and current_user.role?(:admin)
      @student = Student.new(student_params)
    elsif logged_in? and current_user.role?(:parent)
      @student = Student.new(parent_student_params)
      @student.family = current_user.family
    end
    if @student.save
      redirect_to student_path(@student), notice: "#{@student.first_name} #{@student.last_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @student.update(student_params)
      redirect_to student_path(@student), notice: "#{@student.first_name} #{@student.last_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @student.destroy
    redirect_to students_url, notice: "#{@student.first_name} #{@student.last_name} was deleted from the system."
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:first_name, :last_name, :family_id, :date_of_birth, :rating, :active)
    end

    def parent_student_params
      params.require(:student).permit(:first_name, :last_name, :date_of_birth, :rating, :active)
    end
end