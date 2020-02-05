module Contexts
  module InstructorContexts
    def create_instructors
      @mark   = FactoryBot.create(:instructor, user: @mark_user)
      @alex   = FactoryBot.create(:instructor, user: @alex_user, first_name: "Alex", bio: nil)
      @rachel = FactoryBot.create(:instructor, user: @rachel_user, first_name: "Rachel", bio: nil, active: false)
    end

    def delete_instructors
      @mark.delete
      @alex.delete
      @rachel.delete
    end

    def create_more_instructors
      @mike     = FactoryBot.create(:instructor, user: @mark_user, first_name: "Mike", last_name: "Ferraco", bio: "A stupendous chess player as you have ever seen.")
      @patrick  = FactoryBot.create(:instructor, user: @patrick_user, first_name: "Patrick", last_name: "Dustmann", bio: "A stupendous chess player as you have ever seen.")
      @austin   = FactoryBot.create(:instructor, user: @austin_user, first_name: "Austin", last_name: "Bohn", bio: "A stupendous chess player as you have ever seen.")
      @nathan   = FactoryBot.create(:instructor, user: @nathan_user, first_name: "Nathan", last_name: "Hahn", bio: "A stupendous chess player as you have ever seen.")
      @ari      = FactoryBot.create(:instructor, user: @ari_user, first_name: "Ari", last_name: "Rubinstein", bio: "A stupendous chess player as you have ever seen.")
      @seth     = FactoryBot.create(:instructor, user: @seth_user, first_name: "Seth", last_name: "Vargo", bio: "A stupendous chess player as you have ever seen.")
      @stafford = FactoryBot.create(:instructor, user: @stafford_user, first_name: "Stafford", last_name: "Brunk", bio: "A stupendous chess player as you have ever seen.")
      @brad     = FactoryBot.create(:instructor, user: @brad_user, first_name: "Brad", last_name: "Hess", bio: "A stupendous chess player as you have ever seen.")
      @ripta    = FactoryBot.create(:instructor, user: @ripta_user, first_name: "Ripta", last_name: "Pasay", bio: "A stupendous chess player as you have ever seen.")
      @jon      = FactoryBot.create(:instructor, user: @jon_user, first_name: "Jon", last_name: "Hersh", bio: "A stupendous chess player as you have ever seen.")
      @ashton   = FactoryBot.create(:instructor, user: @ashton_user, first_name: "Ashton", last_name: "Thomas", bio: "A stupendous chess player as you have ever seen.")
      @noah     = FactoryBot.create(:instructor, user: @noah_user, first_name: "Noah", last_name: "Levin", bio: "A stupendous chess player as you have ever seen.")
    end

    def delete_more_instructors
      @mike.delete
      @patrick.delete
      @austin.delete
      @nathan.delete
      @ari.delete
      @seth.delete
      @stafford.delete
      @brad.delete
      @ripta.delete
      @jon.delete
      @ashton.delete
      @noah.delete
    end
  end
end