class Curriculum < ApplicationRecord
  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # relationships
  has_many :camps

  # validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  ratings_array = [0] + (100..3000).to_a
  validates :min_rating, numericality: { only_integer: true }, inclusion: { in: ratings_array }
  validates :max_rating, numericality: { only_integer: true }, inclusion: { in: ratings_array }
  validate :max_rating_greater_than_min_rating

  # scopes
  scope :alphabetical, -> { order('name') }
  scope :for_rating, ->(rating) { where("min_rating <= ? and max_rating >= ?", rating, rating) }

  # callbacks
  before_destroy do 
    cannot_destroy_object()
  end

  before_update :check_for_upcoming_registration_before_making_inactive


  private
  def max_rating_greater_than_min_rating
    # only testing 'greater than' in this method, so...
    return true if self.max_rating.nil? || self.min_rating.nil?
    unless self.max_rating > self.min_rating
      errors.add(:max_rating, "must be greater than the minimum rating")
    end
  end

  def check_for_upcoming_registration_before_making_inactive
    return true if self.active
    if any_upcoming_registrations?
      errors.add(:base, "This curriculum has upcoming registrations and cannot be made inactive at this time.")
    end
  end

  def any_upcoming_registrations?
    # find the registration counts for each upcoming camp using this curriculum
    registration_counts = self.camps.upcoming.map{|c| c.registrations.count} 
    # test to see if the total registration count is zero
    registration_counts.inject(0){|sum, rc| sum += rc}.zero?
  end  
end
