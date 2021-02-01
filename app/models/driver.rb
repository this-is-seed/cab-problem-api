class Driver < ApplicationRecord

  include Filterable

  # associations
  has_many :cab_trips

  # validations
  validates :mobile_number, uniqueness: true

  # filters
  scope :active_driver, -> (min_rating) {where(is_active: true).where('rating >= ?', min_rating)}
  scope :by_mobile_number, -> (by_mobile_number) {where(mobile_number: by_mobile_number)}
  scope :by_name, -> (by_name) {where("full_name like ?", "%#{by_name}%")}

  def self.calculate_rating(driver_id)
    driver = Driver.find(driver_id)
    # all trips by driver
    trips = driver.cab_trips.where(status: 'completed')
    # if trips are more than 4 than average of all trips considered else 5 is set as an average trip for the driver
    if trips.size > 4
      rated_trips = trips.where.not(rating: nil)
      avg_rating = rated_trips.average(:rating)
      if avg_rating >= 4
        driver.update(rating: avg_rating, is_active: true)
      else
        # if trips average is less than 4 than inactive the driver so that no further trips are assigned to driver
        driver.update(rating: avg_rating, is_active: false)
      end
    else
      driver.update(rating: 5, is_active: true)
    end
  end
end
