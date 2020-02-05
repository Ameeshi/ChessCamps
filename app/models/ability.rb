class Ability
  include CanCan::Ability

  # def getStudentIDs(instructor_id)
  #   student_ids = []
  #   Instructor.find(instructor_id).camps.each do |c|
  #     student_ids << c.students.map {|s| s.id}
  #   end
  #   return student_ids.flatten
  # end

  # def getFamilyIDs(instructor_id)
  #   family_ids = []
  #   Instructor.find(instructor_id).camps.each do |c|
  #     c.students.each do |s|
  #       family_ids << s.family.id 
  #     end 
  #   end 
  #   return family_ids.flatten 
  # end 

  def initialize(user)
    user ||= User.new
    
    if user.role? :admin
        can :manage, :all
    
    elsif user.role? :instructor
      # can read details for curriculums, locations and camps 
      can :read, Curriculum
      can :read, Location
      can :read, Camp
      can :read, Instructor

      # they can read their own profile
      can :show, User do |u|  
        u.id == user.id
      end

      # they can update their own profile
      can :update, User do |u|  
        u.id == user.id
      end

      can :read, Instructor do |i|
        i.id == user.instructor.id 
      end 

      can :update, Instructor do |i|
        i.id == user.instructor.id 
      end

      # they can read the students' profiles registered for their camps 
      can :read, Student do |s|
        user.instructor.students.map{|stu| stu.id}.include?(s.id)
      end  

      # they can read the parents' profiles of students they are autorized to view 
      can :read, Family do |f|
        user.instructor.families.map{|fam| fam.id}.include?(f.id)
      end  
 

    elsif user.role? :parent 

      can :read, Family do |f|
        f.id == user.family.id 
      end 

      can :update, Family do |f|
        f.id == user.family.id 
      end

      # can read details for curriculums, camps and locations
      can :read, Curriculum
      can :read, Camp
      can :read, Location

      # they can read their own profile
      can :show, User do |u|  
        u.id == user.id
      end

      # they can update their own profile
      can :update, User do |u|  
        u.id == user.id
      end

      can :index, Student

      # they can manage their students and their registrations 
      can :manage, Student do |s|
        user.family.students.map{|stu| stu.id}.include?(s.id)
      end  

      can :manage, Registration do |r|
        user.family.registrations.map{|reg| reg.id}.include?(r.id)
      end 

      can :students, Camp

    else

        can :read, Camp
        can :read, Curriculum
        can :read, Location

        #can create new family and user accounts??
        can :create, User do |u|
            user.role == 'parent'
        end
        can :create, Family

    end 
  end
end
