module ChessCampHelpers
  module Cart
    # For this application, our cart is simply a hash consisting
    # of camp_ids as keys and an array of student_id as values.  The hash is 
    # saved as a session variable that the user should have  
    # available during the course of their interactions w/ system.

    def create_cart
      session[:cart] ||= Hash.new
    end

    def clear_cart
      session[:cart] = Hash.new
    end

    def destroy_cart
      session[:cart] = nil
    end

    def add_registration_to_cart(camp_id, student_id)
      if session[:cart].keys.include?(camp_id)
        # if camp is in cart, add the student id to the values array
        student_ids = session[:cart][camp_id]
        student_ids << student_id  # use the << to add the student_id
        session[:cart][camp_id] = student_ids
      else
        # otherwise, just add registration to the cart
        session[:cart][camp_id] = [student_id]
      end
    end

    def remove_registration_from_cart(camp_id, student_id)
      if session[:cart].keys.include?(camp_id)
        student_ids = session[:cart][camp_id]
        student_ids.delete(student_id)
        session[:cart][camp_id] = student_ids
      end
    end


  end
end