module ApplicationHelper

include AppHelpers::SimpleCart

  def cart_cost
     calculate_cart_cost
  end

  def camp_instructor_id_for(camp, instructor)
    ci = CampInstructor.where(camp_id: camp.id, instructor_id: instructor).first
    return ci.id unless ci.nil?
  end

  def registration_id_for(camp, student)
    r = Registration.where(camp_id: camp.id, student_id: student).first
    return r.id unless r.nil?
  end

  def rating(cur)
    m1 = cur.min_rating
    m2 = cur.max_rating
    if cur.min_rating == 0 
      return "Unrated - #{m2}"
    else 
      return "#{m1} - #{m2}"
    end 
  end

  def time(cmp)
    if cmp.time_slot == 'am'
      return "Morning"
    else 
      return "Afternoon"
    end 
  end

  def reformat_phone(phn)
    unless (phn == '')
      x = phn.insert(-8, '-').insert(-5, '-')
      return x
    end 
    return "N/A"
  end 

end
