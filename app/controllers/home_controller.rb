class HomeController < ApplicationController
  include AppHelpers::SimpleCart

  def index
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def search
    @query = params[:query]
    @instructors = Instructor.search(@query)
    @students = Student.search(@query)
    @families = Family.search(@query)
    @camps = Camp.search(@query)
    @curriculums = Curriculum.search(@query)
    @locations = Location.search(@query)
    @total_hits = @instructors.size + @students.size + @families.size + @locations.size + @curriculums.size + @camps.size
  end

  def view_cart
    if !logged_in? || current_user.nil? || current_user.role?(:admin) || current_user.role?(:instructor)
      flash[:error] = "You are not authorized to take this action. Please log in as an appropriate user."
      redirect_to home_path
    elsif logged_in? and current_user.role?(:parent)
      @cart_items = get_list_of_registrations_in_cart
    end 
  end
  
end