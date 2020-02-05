class CampInstructorsController < ApplicationController
  
  def new
    @camp_instructor   = CampInstructor.new
    @camp              = Camp.find(params[:camp_id])
    @other_instructors = @camp.instructors
  end
  
  def create
    @camp_instructor = CampInstructor.new(camp_instructor_params)
    if @camp_instructor.save
      flash[:notice] = "Successfully added instructor."
      redirect_to camp_path(@camp_instructor.camp)
    else
      @camp = Camp.find(params[:camp_instructor][:camp_id])
      @other_instructors = @camp.instructors
      render action: 'new', locals: { camp: @camp, other_instructors: @other_instructors }
    end
  end
 
  def destroy
    @camp_instructor = CampInstructor.find(params[:id])
    @camp_instructor.destroy
    flash[:notice] = "Successfully removed this instructor."
    redirect_to camp_path(@camp_instructor.camp)
  end

  private
    def camp_instructor_params
      params.require(:camp_instructor).permit(:camp_id, :instructor_id)
    end

end