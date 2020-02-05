module Contexts
  module UserContexts
    # create your contexts here...
    def create_users
      @mark_user = FactoryBot.create(:user)
      @alex_user = FactoryBot.create(:user, username: "tank", phone: "412-369-4314")
      @rachel_user = FactoryBot.create(:user, username: "rachel", role: "instructor")
    end

    def delete_users
      @mark_user.delete
      @alex_user.delete
      @rachel_user.delete
    end

    def create_more_users
      @mike_user     = FactoryBot.create(:user, username: "mike", role: "instructor")
      @patrick_user  = FactoryBot.create(:user, username: "patrick", role: "instructor")
      @austin_user   = FactoryBot.create(:user, username: "austin", role: "instructor")
      @nathan_user   = FactoryBot.create(:user, username: "nathan", role: "instructor")
      @ari_user      = FactoryBot.create(:user, username: "ari", role: "instructor")
      @seth_user     = FactoryBot.create(:user, username: "seth", role: "instructor")
      @stafford_user = FactoryBot.create(:user, username: "stafford", role: "instructor")
      @brad_user     = FactoryBot.create(:user, username: "brad", role: "instructor")
      @ripta_user    = FactoryBot.create(:user, username: "ripta", role: "instructor")
      @jon_user      = FactoryBot.create(:user, username: "jon", role: "instructor")
      @ashton_user   = FactoryBot.create(:user, username: "ashton", role: "instructor")
      @noah_user     = FactoryBot.create(:user, username: "noah", role: "instructor")
    end

    def delete_more_users
      @mike_user.delete    
      @patrick_user.delete
      @austin_user.delete
      @nathan_user.delete
      @ari_user.delete
      @seth_user.delete
      @stafford_user.delete
      @brad_user.delete
      @ripta_user.delete
      @jon_user.delete
      @ashton_user.delete
      @noah_user.delete
    end

    def create_family_users
      @gruberman_user = FactoryBot.create(:user, username: "gruberman", role: "parent")
      @skirpan_user   = FactoryBot.create(:user, username: "skripan", role: "parent")
      @regan_user     = FactoryBot.create(:user, username: "regan", role: "parent")
      @ellis_user     = FactoryBot.create(:user, username: "ellis", role: "parent")

    end

    def delete_family_users
      @gruberman_user.delete
      @skirpan_user.delete
      @regan_user.delete
      @ellis_user.delete
    end
  end
end