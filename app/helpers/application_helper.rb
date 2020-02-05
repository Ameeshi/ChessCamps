module ApplicationHelper
  def camp_instructor_id_for(camp, instructor)
    ci = CampInstructor.where(camp_id: camp.id, instructor_id: instructor).first
    return ci.id unless ci.nil?
  end
end
