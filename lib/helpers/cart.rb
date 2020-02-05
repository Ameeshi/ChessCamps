module AppHelpers
  module Cart
    # For this application, our cart is simply an array consisting
    # of CartItem structs.  The array is saved as a session variable
    # that the user should have available during the course of their 
    # interactions w/ system.

    CartItem = Struct.new(:camp_name, :student_name, :date, :cost, :ids)

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
      unless session[:cart].map{|ci| ci.ids}.include? [camp_id, student_id]
        # if not, create a cart item for easy display later
        camp = Camp.find(camp_id)
        camp_name = camp.name
        student_name = Student.find(student_id).first_name
        date = camp.start_date
        cost = camp.cost
        ids = [camp_id, student_id]
        ci = CartItem.new(camp_name, student_name, date, cost, ids)
        session[:cart].push(ci)
      end
    end

    def remove_registration_from_cart(camp_id, student_id)
      session[:cart].each do |ci|
        session[:cart].delete(ci) if ci.ids == [camp_id, student_id]
      end
    end

    def calculate_total_cart_registration_cost
      total = 0.0
      return total if session[:cart].empty? # skip if cart empty...
      session[:cart].each do |cart_item|
        total += cart_item.cost
      end
      total
    end

    def get_array_of_ids_for_generating_registrations
      unless session[:cart].nil? || session[:cart].empty?
        reg_ids = session[:cart].map{|ci| ci.ids}
      end
      return reg_ids
    end

  end
end