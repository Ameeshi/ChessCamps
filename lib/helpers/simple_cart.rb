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

    def calculate_cart_cost
      total = 0
      return total if session[:cart].empty? # skip if cart empty...
      session[:cart].each do |camp_id, student_id|
        camp = Camp.find(camp_id)
        total += camp.cost
      end
      total
    end


    def get_list_of_registrations_in_cart
      new_registrations = []
      return new_registrations if session[:cart].empty? # skip if cart empty...
      session[:cart].each do |camp_id, student_id|
        camp = Camp.find(camp_id)
        camp_name = camp.name
        student_name = Student.find(student_id).first_name
        start_date = camp.start_date.strftime("%m/%d/%y")
        end_date = camp.end_date.strftime("%m/%d/%y")
        cost = camp.cost
        cart_deets = [camp_name, student_name, start_date, cost, camp_id, student_id, end_date]
        new_registrations << cart_deets
      end
      new_registrations    
    end

    def save_each_registration_in_cart(order)
      session[:cart].each do |camp_id, student_id|
        info = {camp_id: camp_id, order_id: order.id}
        Registration.create(info)
      end
    end

  end
end