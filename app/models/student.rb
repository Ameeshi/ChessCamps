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
