class Student < ApplicationRecord
  include AppHelpers::Validations
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # relationships
  belongs_to :family
  has_many :registrations
  has_many :camps, through: :registrations

  # validations
  validates_presence_of :family_id, :first_name, :last_name
  ratings_array = [0] + (100..3000).to_a
  validates :family_id, numericality: { only_integer: true, greater_than: 0 }
  validates :rating, numericality: { only_integer: true, allow_blank: true }, inclusion: { in: ratings_array, allow_blank: true }  
  validates_date :date_of_birth, :before => lambda { Date.today }, :before_message => "cannot be in the future", allow_blank: true, on: :create
  validate :family_is_active_in_the_system, on: :create

  # scopes
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :below_rating, ->(ceiling) { where('rating < ?', ceiling) }
  scope :at_or_above_rating, ->(floor) { where('rating >= ?', floor) }
  scope :search, ->(term) { where('first_name LIKE ? OR last_name LIKE ?', "#{term}%", "#{term}%") }


  def self.for_camp(camp)
    # the 'instructive way'... (which I told you if you asked me for help)
    # the easy way... 
    camp.students
  end

  # callbacks
  before_save :set_unrated_to_zero

  before_update :remove_upcoming_registrations_if_inactive

  before_destroy do 
   check_if_ever_registered_for_past_camp
   if errors.present?
     @destroyable = false
     throw(:abort)
   else
     remove_upcoming_registrations
   end
  end

  after_rollback :convert_to_inactive_and_remove_registrations

  def self.can_attend(camp, family)
    students = Student.where(family_id: family.id).active.alphabetical
    result = []
    students.each do |s|
      if (camp.curriculum.min_rating..camp.curriculum.max_rating).cover?(s.rating)
        result << s
      end
    end
    final = []
    students_in_other_camps = []
    camps = Camp.where(start_date: camp.start_date, time_slot: camp.time_slot)
    camps.each do |c|
      students_in_other_camps = students_in_other_camps + c.students
    end
    result.each do |i|
      if !students_in_other_camps.include?(i)
        final << i
      end
    end
    if camp.is_full?
      return []
    else 
      return final
    end
  end

  def self.can_attend_2(camp)
    students = Student.active.alphabetical
    result = []
    students.each do |s|
      if (camp.curriculum.min_rating..camp.curriculum.max_rating).cover?(s.rating)
        result << s
      end
    end
    final = []
    students_in_other_camps = []
    camps = Camp.where(start_date: camp.start_date, time_slot: camp.time_slot)
    camps.each do |c|
      students_in_other_camps = students_in_other_camps + c.students
    end
    result.each do |i|
      if !students_in_other_camps.include?(i)
        final << i
      end
    end
    if camp.is_full?
      return []
    else 
      return final
    end
  end 

  # other methods
  def name
    "#{self.last_name}, #{self.first_name}"
  end

  def proper_name
    "#{self.first_name} #{self.last_name}"
  end

  def age
    return nil if date_of_birth.blank?
    (Time.now.to_s(:number).to_i - date_of_birth.to_time.to_s(:number).to_i)/10e9.to_i
  end

  # private
  def set_unrated_to_zero
    self.rating ||= 0
  end

  def family_is_active_in_the_system
    is_active_in_system(:family)
  end

  def registered_for_past_camps?
    !self.registrations.select{|r| r.camp.start_date < Date.current}.empty?
  end

  def check_if_ever_registered_for_past_camp
    return if self.registrations.empty?
    if registered_for_past_camps?
      errors.add(:base, "This student has registered for a past camp and cannot be deleted, but has been made inactive.")
    end
  end

  def remove_upcoming_registrations
    return true if self.registrations.empty?
    upcoming_registrations = self.registrations.select{|r| r.camp.start_date >= Date.current}
    upcoming_registrations.each{ |ur| ur.destroy }
  end

  def convert_to_inactive_and_remove_registrations
    if @destroyable == false
      remove_upcoming_registrations
      self.make_inactive
    end
    @destroyable = nil
  end

  def remove_upcoming_registrations_if_inactive
    remove_upcoming_registrations if !self.active 
  end
end
