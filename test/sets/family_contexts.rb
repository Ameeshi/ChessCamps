module Contexts
  module FamilyContexts
    # create your contexts here...
    def create_families
      @grubermans = FactoryBot.create(:family, user: @gruberman_user)
      @skirpans   = FactoryBot.create(:family, user: @skirpan_user, family_name: "Skirpan", parent_first_name: "Ellen")
      @regans     = FactoryBot.create(:family, user: @regan_user, family_name: "Regan", parent_first_name: "Patrick")
    end

    def delete_families
      @grubermans.delete
      @regans.delete
      @skirpans.delete
    end

    def create_inactive_families
      @ellis = FactoryBot.create(:family, user: @ellis_user, family_name: "Ellis", parent_first_name: "Carolyn", active: false)
    end

    def delete_inactive_families
      @ellis.delete
    end
  end
end