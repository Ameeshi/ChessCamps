class Location < ApplicationRecord
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # relationships
  has_many :camps

  # states list
  STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']]

  # validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :street_1, presence: true
  validates :state, inclusion: { in: STATES_LIST.map{|a,b| b}, message: "is not valid state", allow_blank: true }
  validates :zip, presence: true, format: { with: /\A\d{5}\z/, message: "should be five digits long", allow_blank: true }
  validates :max_capacity, presence: true, numericality: { only_integer: true, greater_than: 0, allow_blank: true }
  
  # scopes
  scope :alphabetical, -> { order('name') }

  # callbacks
  before_destroy do 
    check_if_ever_used_for_past_camp
    if errors.present?
      @destroyable = false
      throw(:abort)
    end
    # we should actually handling upcoming camps -- what if 
    # there are upcoming camps but no registrations, and the
    # like -- but cutting things back for this phase. Also not
    # handling any deactivation issues for location for now.
  end

  private
  def check_if_ever_used_for_past_camp
    unless self.camps.past.empty?
      errors.add(:base, "This location has been used for camps in the past and cannot be destroyed.")
    end
  end
end
