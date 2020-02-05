class Camp < ApplicationRecord
  include AppHelpers::Validations
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # relationships
  belongs_to :curriculum
  belongs_to :location
  has_many :camp_instructors
  has_many :instructors, through: :camp_instructors
  has_many :registrations
  has_many :students, through: :registrations

  # validations
  validates_presence_of :curriculum_id, :time_slot, :start_date, :location_id
  validates_numericality_of :cost, greater_than_or_equal_to: 0
  validates_date :start_date, :on_or_after => lambda { Date.today }, :on_or_after_message => "cannot be in the past", on:  :create
  validates_date :end_date, :on_or_after => :start_date
  validates_inclusion_of :time_slot, in: %w[am pm], message: "is not an accepted time slot"
  validates_numericality_of :max_students, only_integer: true, greater_than: 0, allow_blank: true
  validate :curriculum_is_active_in_the_system
  validate :location_is_active_in_the_system
  validate :camp_is_not_a_duplicate, on: :create
  validate :max_students_not_greater_than_capacity
  validate :camp_can_be_deactivated

  # scopes
  scope :alphabetical, -> { joins(:curriculum).order('name') }
  scope :chronological, -> { order('start_date','end_date') }
  scope :morning, -> { where('time_slot = ?','am') }
  scope :afternoon, -> { where('time_slot = ?','pm') }
  scope :upcoming, -> { where('start_date >= ?', Date.today) }
  scope :past, -> { where('end_date < ?', Date.today) }
  scope :for_curriculum, ->(curriculum_id) { where("curriculum_id = ?", curriculum_id) }
  scope :full, -> { joins(:registrations).group(:camp_id).having('count(*) = max_students') }
  scope :empty, -> { joins("left join registrations on camps.id=registrations.camp_id").where("registrations.student_id is null") }


  # instance methods
  def name
    self.curriculum.name
  end

  def already_exists?
    Camp.where(time_slot: self.time_slot, start_date: self.start_date, location_id: self.location_id).size == 1
  end

  def is_full?
    self.max_students == self.registrations.count
  end

  def enrollment
    self.registrations.count
  end

  # class methods
  def self.openings
    Camp.active.chronological.to_a.select{|c| c.registrations.size < c.max_students}
  end

  # callbacks
  before_destroy do 
    check_if_anyone_is_registered_for_camp
    if errors.present?
      throw(:abort)
    else
      remove_camp_instructors
    end
  end

  before_update :camp_can_be_deactivated

  private
  def curriculum_is_active_in_the_system
    is_active_in_system(:curriculum)
  end

  def location_is_active_in_the_system
    is_active_in_system(:location)
  end

  def camp_is_not_a_duplicate
    return true if self.time_slot.nil? || self.start_date.nil? || self.location_id.nil?
    if self.already_exists?
      errors.add(:time_slot, "already exists for start date, time slot and location")
    end
  end

  def any_registrations_for_camp?
    !self.registrations.to_a.empty?
  end

  def camp_can_be_deactivated
    return true if self.active
    if any_registrations_for_camp?
      errors.add(:base, "Camp cannot be inactive because there are students registered")
    end
  end

  def check_if_anyone_is_registered_for_camp
    if any_registrations_for_camp?
      errors.add(:base, "Camp cannot be deleted because there are students registered")
    end
  end

  def max_students_not_greater_than_capacity
    return true if self.max_students.nil? || self.location_id.nil?
    if self.max_students > self.location.max_capacity
      errors.add(:max_students, "is greater than the location capacity")
    end
  end

  def remove_camp_instructors
    self.camp_instructors.each{|ci| ci.destroy}
  end

end
