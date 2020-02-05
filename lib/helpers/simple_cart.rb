module AppHelpers
  module SimpleCart
    # For this application, our cart is simply an array consisting of
    # pairs of camp and student id arrays.  The array is saved as a 
    # session variable that the user should have available during the  
    # course of their interactions w/ system.


    def create_cart
      session[:cart] ||= Array.new
    end

    def clear_cart
      session[:cart] = Array.new
    end

    def destroy_cart
      session[:cart] = nil
    end

    def add_registration_to_cart(camp_id, student_id)
      # only add the registration if not already in the cart
      unless session[:cart].include? [camp_id, student_id]
        session[:cart].push([camp_id, student_id])
      end
    end

    def remove_registration_from_cart(camp_id, student_id)
      if session[:cart].include? [camp_id, student_id]
        session[:cart].delete([camp_id, student_id])
      end
    end

  end
end