module Contexts
  module RegistrationContexts

    def create_registrations
      @max_tactics    = FactoryBot.create(:registration, camp: @camp1, student: @max)
      @peter_endgames = FactoryBot.create(:registration, camp: @camp4, student: @peter)
      @peter_tactics  = FactoryBot.create(:registration, camp: @camp1, student: @peter)
      @zach_endgames  = FactoryBot.create(:registration, camp: @camp4, student: @zach)
      @kelsey_endgames = FactoryBot.create(:registration, camp: @camp4, student: @kelsey)
    end

    def delete_registrations
      @max_tactics.delete
      @peter_endgames.delete
      @peter_tactics.delete
      @zach_endgames.delete
      @kelsey_endgames.delete
    end
  end
end