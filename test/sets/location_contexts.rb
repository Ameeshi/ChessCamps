module Contexts
  module LocationContexts

    def create_active_locations
      @north = FactoryBot.create(:location, name: "North Side", street_1: "801 Union Place", street_2: nil, city: "Pittsburgh", zip: "15212")
      # switched order so alphabetical is not same as order created
      @cmu = FactoryBot.create(:location) 
    end

    def delete_active_locations
      @cmu.delete
      @north.delete
    end

    def create_inactive_locations
      @sqhill = FactoryBot.create(:location, name: "Squirrel Hill", street_1: "5738 Forbes Avenue", street_2: nil, city: "Pittsburgh", zip: "15217", active: false)
    end

    def delete_inactive_locations
      @sqhill.delete
    end

    def create_locations_never_used_by_camps
      @acac = FactoryBot.create(:location, name: "ACAC", street_1: "250 East Ohio St", street_2: nil, city: "Pittsburgh", zip: "15212")
    end

    def delete_locations_never_used_by_camps
      @acac.delete
    end

    def create_locations
      create_active_locations
      create_inactive_locations
      create_locations_never_used_by_camps
    end

    def delete_locations
      delete_active_locations
      delete_inactive_locations
      delete_locations_never_used_by_camps
    end
  end
end