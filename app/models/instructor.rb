class Instructor < ApplicationRecord
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # relationships
  belongs_to :user
  has_many :camp_instructors
  has_many :camps, through: :camp_instructors

  # validations
  validates_presence_of :first_name, :last_name

  # scopes
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :needs_bio, -> { where(bio: nil) }

  # class methods
  def self.for_camp(camp)
    # the 'instructive way'... (which I told you if you asked me for help)
    CampInstructor.where(camp_id: camp.id).map{ |ci| ci.instructor }
    # the easy way... 
    # camp.instructors
  end

  # delegates
  delegate :email, to: :user, allow_nil: true
  delegate :phone, to: :user, allow_nil: true
  delegate :username, to: :user, allow_nil: true

  # callbacks
  before_update :deactive_user_if_instructor_inactive

  before_destroy do
    check_if_instructor_taught_past_camps
    if errors.present?
      @destroyable = false
      throw(:abort)
    else
      destroy_user_account
    end
  end

  after_rollback :convert_to_inactive_and_remove_upcoming_camps

  # instance methods
  def name
    last_name + ", " + first_name
  end
  
  def proper_name
    first_name + " " + last_name
  end

  private
  def deactive_user_if_instructor_inactive
    if !self.active && !self.user.nil?
      self.user.active = false
      self.user.save
    end
  end

  def check_if_instructor_taught_past_camps
    unless self.camps.past.empty?
      errors.add(:base, 'You are not allowed to delete this instructor because he/she tuaght past camps.')
    end
  end

  def destroy_user_account
    self.user.destroy
  end

  def convert_to_inactive_and_remove_upcoming_camps
    if @destroyable == false
      remove_upcoming_camps
      self.make_inactive
    end
    @destroyable = nil
  end

  def remove_upcoming_camps
    self.camp_instructors.select{|ci| ci.camp.start_date >= Date.current}.each{|ci| ci.destroy}
  end

end