namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    # Drop the old db and recreate from scratch
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    # Invoke rake db:migrate
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke
    # Need gem to make this work when adding students later: faker
    # Docs at: http://faker.rubyforge.org/rdoc/
    require 'faker'
    require 'factory_bot_rails'

    # Step 1: Create some instructors
    mark_user = User.new
    mark_user.role = "admin"
    mark_user.password = "secret"
    mark_user.password_confirmation = "secret"
    mark_user.username = "mark"
    mark_user.phone = "4122688211"
    mark_user.email = "mark@razingrooks.org"
    mark_user.active = true
    mark_user.save!
    mark = Instructor.new
    mark.first_name = "Mark"
    mark.last_name = "Heimann"
    mark.bio = "Mark is currently among the top 150 players in the United States (USCF rating: 2468) and has won 4 national scholastic chess championships.  Mark is currently working on his Ph.D. in computer science at the University of Michigan and plays for the school's chess team."
    mark.user_id = mark_user.id
    mark.active = true
    mark.save!
    
    alex_user = User.new
    alex_user.role = "admin"
    alex_user.password = "secret"
    alex_user.password_confirmation = "secret"
    alex_user.username = "alex"
    alex_user.phone = "4122688211"
    alex_user.email = "alex@razingrooks.org"
    alex_user.active = true
    alex_user.save!
    alex = Instructor.new
    alex.first_name = "Alex"
    alex.last_name = "Heimann"
    alex.bio = "Alex has earned his Life Master title with a current USCF rating of 2375.  Alex has won 4 national scholastic chess championships as well as 2 national bughouse championships.  Alex graduated from Wheaton College in Illinios where he majored in business with a minor in anthropology and played ultimate frisbee."
    alex.user_id = alex_user.id
    alex.active = true
    alex.save!

    rachel_user = User.new
    rachel_user.role = "instructor"
    rachel_user.password = "secret"
    rachel_user.password_confirmation = "secret"
    rachel_user.username = "rachel"
    rachel_user.phone = "4122688211"
    rachel_user.email = "rachel@example.com"
    rachel_user.active = false
    rachel_user.save!
    rachel = Instructor.new
    rachel.first_name = "Rachel"
    rachel.last_name = "Heimann"
    rachel.bio = "Rachel is an amazing chess player and regularly beats her brothers, Alex and Mark.  Unfortunately she is currently unable to teach for any of the chess camps at this time."
    rachel.user_id = rachel_user.id
    rachel.active = false
    rachel.save!

    becca_user = User.new
    becca_user.role = "instructor"
    becca_user.password = "secret"
    becca_user.password_confirmation = "secret"
    becca_user.username = "becca"
    becca_user.email = "becca@razingrooks.org"
    becca_user.phone = "412-268-3259"
    becca_user.active = true
    becca_user.save!
    becca = Instructor.new
    becca.first_name = "Becca"
    becca.last_name = "Kern"
    becca.user_id = becca_user.id
    becca.bio = "Great TA for 67-272; hopefully can teach chess too."
    becca.active = true
    becca.save!
       
    jordan_user = User.new
    jordan_user.role = "instructor"
    jordan_user.password = "secret"
    jordan_user.password_confirmation = "secret"
    jordan_user.username = "jordan"
    jordan_user.email = "jordan@razingrooks.org"
    jordan_user.phone = "412-268-3259"
    jordan_user.active = true
    jordan_user.save! 
    jordan = Instructor.new
    jordan.first_name = "Jordan"
    jordan.last_name = "Stapinski"
    jordan.user_id = jordan_user.id
    jordan.bio = "Great TA for 67-272; hopefully can teach chess too."
    jordan.active = true
    jordan.save!

    rick_user = User.new
    rick_user.role = "instructor"
    rick_user.password = "secret"
    rick_user.password_confirmation = "secret"
    rick_user.username = "rick"
    rick_user.email = "rick@razingrooks.org"
    rick_user.phone = "412-268-3259"
    rick_user.active = true
    rick_user.save!
    rick = Instructor.new
    rick.first_name = "Rick"
    rick.last_name = "Huang"
    rick.user_id = rick_user.id
    rick.bio = "Great TA for 67-272; hopefully can teach chess too."
    rick.active = true
    rick.save!

    connor_user = User.new
    connor_user.role = "instructor"
    connor_user.password = "secret"
    connor_user.password_confirmation = "secret"
    connor_user.username = "connor"
    connor_user.email = "connor@razingrooks.org"
    connor_user.phone = "412-268-3259"    
    connor_user.active = true
    connor_user.save!
    connor = Instructor.new
    connor.first_name = "Connor"
    connor.last_name = "Hanley"
    connor.user_id = connor_user.id
    connor.bio = "Great TA for 67-272; hopefully can teach chess too."
    connor.active = true
    connor.save!

    sarah_user = User.new
    sarah_user.role = "instructor"
    sarah_user.password = "secret"
    sarah_user.password_confirmation = "secret"
    sarah_user.username = "sarah"
    sarah_user.email = "sarah@razingrooks.org"
    sarah_user.phone = "412-268-3259"
    sarah_user.active = true
    sarah_user.save!
    sarah = Instructor.new
    sarah.first_name = "Sarah"
    sarah.last_name = "Reyes-Franco"
    sarah.user_id = sarah_user.id
    sarah.bio = "Great TA for 67-272; hopefully can teach chess too."
    sarah.active = true
    sarah.save!

    lead_instructors = [mark,alex,becca,sarah]
    assistants = [jordan,rick,connor]
    puts "Created instructors and users"

    # Step 2: Create some curriculum
    beginners = Curriculum.new
    beginners.name = "Principles of Chess"
    beginners.min_rating = 0
    beginners.max_rating = 500
    beginners.description = "This camp is designed for beginning students who know need to learn opening principles, pattern recognition and basic tactics and mates.  Students will be given a set of mate-in-one flashcards and are expected to work on these at home during the week."
    beginners.active = true
    beginners.save!

    tactics = Curriculum.new
    tactics.name = "Mastering Chess Tactics"
    tactics.min_rating = 400
    tactics.max_rating = 850
    tactics.description = "This camp is designed for any student who has mastered basic mating patterns and understands opening principles and is looking to improve his/her ability use chess tactics in game situations. Students will be given a set of tactical flashcards and are expected to work on these at home during the week."
    tactics.active = true
    tactics.save!

    tal = Curriculum.new
    tal.name = "The Tactics of Mikhail Tal"
    tal.min_rating = 800
    tal.max_rating = 3000
    tal.description = "Tal is one of the most admired world champions and often called the Wizard from Riga for his almost magical play.  His chess genius was most clearly seen in his amazing sacrifices and dazzling tactics and in this camp we will dissect these thoroughly so students can learn from them."
    tal.active = false
    tal.save!

    nimzo = Curriculum.new
    nimzo.name = "Nimzo-Indian Defense"
    nimzo.min_rating = 1000
    nimzo.max_rating = 3000
    nimzo.description = "This camp is for intermediate and advanced players who are looking for a good defense to play against 1. d4.  Many world champions, including Mikhail Tal and Garry Kasparov, have played this defense with great success.  Students will have 4 to 6 games to review each day at home as homework."
    nimzo.active = true
    nimzo.save!

    endgames = Curriculum.new
    endgames.name = "Endgame Principles"
    endgames.min_rating = 750
    endgames.max_rating = 1500
    endgames.description = "In this camp we focus on mastering endgame principles and tactics.  We will focus primarily on King-pawn and King-rook endings, but other endings will be covered as well. Complete games will not be played during this camp, but students will compete through a series of endgame exercises for points and awards."
    endgames.active = true
    endgames.save!

    nonbeginner_curriculums = [tactics, nimzo, endgames]
    puts "Created curriculums"

    # Step 3: Create some locations
    north = FactoryBot.create(:location, name: "North Side", street_1: "801 Union Place", street_2: nil, city: "Pittsburgh", zip: "15212")
    cmu = FactoryBot.create(:location) 
    sqhill = FactoryBot.create(:location, name: "Squirrel Hill", street_1: "5738 Forbes Avenue", street_2: nil, city: "Pittsburgh", zip: "15217")
    acac = FactoryBot.create(:location, name: "ACAC", street_1: "250 East Ohio St", street_2: nil, city: "Pittsburgh", zip: "15212")
    all_locations = [cmu, north, sqhill, acac]
    puts "Created locations"

    # Step 4: Create some camps and assign to instructors
    dates = [[Date.new(2018,6,11),Date.new(2018,6,15)],
             [Date.new(2018,6,18),Date.new(2018,6,22)],
             [Date.new(2018,6,25),Date.new(2018,6,29)],
             [Date.new(2018,7,9),Date.new(2018,7,13)],
             [Date.new(2018,7,16),Date.new(2018,7,20)],
             [Date.new(2018,7,23),Date.new(2018,7,27)],
             [Date.new(2018,7,30),Date.new(2018,8,3)],
             [Date.new(2018,8,6),Date.new(2018,8,10)],
             [Date.new(2018,8,13),Date.new(2018,8,17)],
             [Date.new(2018,8,20),Date.new(2018,8,24)]]

    dates.each do |starting, ending|
      ["am","pm"].each do |slot|
        possible_locations = all_locations.clone
        possible_curriculums = nonbeginner_curriculums.clone
        first_location = possible_locations.sample
        # every session we teach a beginner's camp
        camp1 = FactoryBot.create(:camp, curriculum: beginners, start_date: starting, end_date: ending, location: first_location, time_slot: slot)
        # assign an instructor and possibly an assistant
        possible_leads = lead_instructors.clone
        lead_instructor = possible_leads.sample
        possible_assistants = assistants.clone
        assistant = possible_assistants.sample
        lead1 = FactoryBot.create(:camp_instructor, instructor: lead_instructor, camp: camp1)
        assistant = FactoryBot.create(:camp_instructor, instructor: assistant, camp: camp1)

        possible_locations.delete(first_location)
        possible_leads.delete(lead_instructor)
        next_lead = possible_leads.sample
        second_location = possible_locations.sample
        curric1 = possible_curriculums.sample
        # ... and one non-beginner's camp
        camp2 = FactoryBot.create(:camp, curriculum: curric1, start_date: starting, end_date: ending, location: second_location, time_slot: slot)
        lead2 = FactoryBot.create(:camp_instructor, instructor: next_lead, camp: camp2)

        # about 20 percent of the time add a third camp during this session
        if rand(5).zero? 
          possible_locations.delete(second_location)
          third_location = possible_locations.sample
          possible_curriculums.delete(curric1)
          curric2 = possible_curriculums.sample
          possible_leads.delete(next_lead)
          last_lead = possible_leads.sample
          camp3 = FactoryBot.create(:camp, curriculum: curric2, start_date: starting, end_date: ending, location: third_location, time_slot: slot)
          lead3 = FactoryBot.create(:camp_instructor, instructor: last_lead, camp: camp3)
        end
      end
    end
    puts "Created camps"

    # Step 5: Create 100 families
    100.times do
      family_name = Faker::Name.last_name
      parent_first_name = Faker::Name.first_name 
      username = "#{family_name}#{rand(9999)}"
      family_user = FactoryBot.create(:user, username: username, role: "parent")
      FactoryBot.create(:family, family_name: family_name, parent_first_name: parent_first_name, user: family_user)
    end

    puts "Created families and users"

    all_families = Family.all

    # Step 6: Create some students (in three blocks)
    beginner_camps = Camp.where(curriculum_id: beginners.id).chronological.all
    beginner_camps.each do |camp|
      [7,8].sample.times do
        this_family = all_families.sample
        if rand(6).zero?
            last_name = Faker::Name.last_name
        else
            last_name = this_family.family_name
        end
        first_name = Faker::Name.first_name
        dob = (5..12).to_a.sample.years.ago.to_date
        rating = (rand(2).zero? ? 0 : (100..399).to_a.sample)
        beginner_student = FactoryBot.create(:student, family: this_family, first_name: first_name, last_name: last_name, date_of_birth: dob, rating: rating)
        payment = ["YmVjY2E6c2VjcmV0", "a883c963cbed6699", "de60c7ee64208fa803"].sample
        FactoryBot.create(:registration, camp: camp, student: beginner_student, payment: payment)
      end
    end
    puts "Created students and registrations for beginners camp"

    tactics_camps = Camp.where(curriculum_id: tactics.id).chronological.all
    tactics_camps.each do |camp|
      [7,8].sample.times do
        this_family = all_families.sample
        if rand(6).zero?
            last_name = Faker::Name.last_name
        else
            last_name = this_family.family_name
        end
        first_name = Faker::Name.first_name
        dob = (7..15).to_a.sample.years.ago.to_date
        rating = (525..825).to_a.sample
        tactics_student = FactoryBot.create(:student, family: this_family, first_name: first_name, last_name: last_name, date_of_birth: dob, rating: rating)
        payment = ["YmVjY2E6c2VjcmV0", "a883c963cbed6699", "de60c7ee64208fa803"].sample
        FactoryBot.create(:registration, camp: camp, student: tactics_student, payment: payment)
      end
    end
    puts "Created students and registrations for Tactics camp"

    nimzo_camps = Camp.where(curriculum_id: nimzo.id).chronological.all
    nimzo_camps.each do |camp|
      (5..8).to_a.sample.times do
        this_family = all_families.sample
        if rand(6).zero?
            last_name = Faker::Name.last_name
        else
            last_name = this_family.family_name
        end
        first_name = Faker::Name.first_name
        dob = (8..17).to_a.sample.years.ago.to_date
        rating = (1001..1498).to_a.sample
        nimzo_student = FactoryBot.create(:student, family: this_family, first_name: first_name, last_name: last_name, date_of_birth: dob, rating: rating)
        payment = ["YmVjY2E6c2VjcmV0", "a883c963cbed6699", "de60c7ee64208fa803"].sample
        FactoryBot.create(:registration, camp: camp, student: nimzo_student, payment: payment)
        if rand(2).zero?
            # using case as demo
            case camp.time_slot
            when "am"
                alt_time = "pm"
            else
                alt_time = "am"
            end
          endgame_camp = Camp.where(curriculum_id: endgames.id, time_slot: alt_time).sample
          FactoryBot.create(:registration, camp: endgame_camp, student: nimzo_student, payment: payment)
        end
      end
    end
    puts "Created students and registrations for Nimzo-Indian camp"

  end
end