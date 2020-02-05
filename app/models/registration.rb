class Registration < ApplicationRecord
  include AppHelpers::Validations
  require 'base64'

  # Virtual attributes (non-saved)
  attr_accessor :credit_card_number
  attr_accessor :expiration_year
  attr_accessor :expiration_month

  # relationships
  belongs_to :camp
  belongs_to :student
  has_one :family, through: :student

  # validations
  validates :camp_id, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :student_id, presence: true, numericality: { greater_than: 0, only_integer: true }
  validate :student_is_active_in_the_system, on: :create
  validate :camp_is_active_in_the_system, on: :create
  validate :student_rating_appropriate_for_camp, on: :create
  validate :student_is_not_already_registered_to_another_camp_at_same_time, on: :create
  validate :credit_card_number_is_valid
  validate :expiration_date_is_valid

  # scopes
  scope :for_camp, ->(camp_id) { where(camp_id: camp_id) }
  scope :alphabetical, -> { joins(:student).order('students.last_name, students.first_name') }

  # other methods
  def pay
    return false unless self.payment.nil?
    generate_payment_receipt
    self.save!
    self.payment
  end

  def credit_card_type
    credit_card.type.nil? ? "N/A" : credit_card.type.name
  end


  private
  def student_rating_appropriate_for_camp
    return true if camp_id.nil? || student_id.nil?
    unless (camp.curriculum.min_rating..camp.curriculum.max_rating).cover?(student.rating)
      errors.add(:base, "Student rating not within bounds for camp")
    end
  end

  def student_is_not_already_registered_to_another_camp_at_same_time
    return true if self.camp.nil? || self.student.nil?
    students_registered_at_that_time = Camp.where(start_date: self.camp.start_date, time_slot: self.camp.time_slot).map{|c| c.students }.flatten
    if students_registered_at_that_time.include?(self.student)
      errors.add(:base, "Student is already registered for another camp at this time")
    end
  end

  def student_is_active_in_the_system
    is_active_in_system(:student)
  end

  def camp_is_active_in_the_system
    is_active_in_system(:camp)
  end

  def generate_payment_receipt
    self.payment = Base64.encode64("camp: #{self.camp_id}; student: #{self.student_id}; amount_paid: #{self.camp.cost}; card: #{self.credit_card_type} ****#{self.credit_card_number[-4..-1]}")
  end

  def credit_card
    CreditCard.new(self.credit_card_number, self.expiration_year, self.expiration_month)
  end

  def credit_card_number_is_valid
    return false if self.expiration_year.nil? || self.expiration_month.nil?
    if self.credit_card_number.nil? || credit_card.type.nil?
      errors.add(:credit_card_number, "is not valid")
      return false
    end
    true
  end

  def expiration_date_is_valid
    return false if self.credit_card_number.nil? 
    if self.expiration_year.nil? || self.expiration_month.nil? || credit_card.expired?
      errors.add(:expiration_year, "is expired")
      return false
    end
    true
  end
end
