module AppHelpers
  module DemoCart
    # For this application, our cart is simply an array consisting
    # of CartItem structs.  The array is saved as a session variable
    # that the user should have available during the course of their 
    # interactions w/ system.

    CartItem = Struct.new(:camp_name, :student_name, :date, :cost, :ids)

    def create_cart
      Array.new
    end

    def add_registration_to_cart(cart, camp_id, student_id)
      # only add the registration if not already in the cart
      unless cart.map{|ci| ci.ids}.include? [camp_id, student_id]
        # if not, create a cart item for easy display later
        camp = Camp.find(camp_id)
        camp_name = camp.name
        student_name = Student.find(student_id).first_name
        date = camp.start_date
        cost = camp.cost
        ids = [camp_id, student_id]
        ci = CartItem.new(camp_name, student_name, date, cost, ids)
        cart.push(ci)
      end
    end

    def calculate_total_cart_registration_cost(cart)
      total = 0.0
      return total if cart.empty? # skip if cart empty...
      cart.each do |cart_item|
        total += cart_item.cost
      end
      total
    end

    def get_array_of_ids_for_generating_registrations(cart)
      unless cart.nil? || cart.empty?
        reg_ids = cart.map{|ci| ci.ids}
      end
      return reg_ids
    end

  end
end