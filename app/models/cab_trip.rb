class CabTrip < ApplicationRecord

  include Filterable

  # associations
  belongs_to :customer
  belongs_to :driver

  STATUS = %w{confirmed cancelled ongoing completed}.freeze

  # validations
  validates :status, presence: true, inclusion: {in: STATUS}
  validates :ride_number, uniqueness: true
  validate :customer_trip, :on => :create
  validates :customer_id, presence: true
  validates :driver_id, presence: true

  # filters
  scope :by_customer, -> (by_customer) {where(customer_id: by_customer)}
  scope :by_driver, -> (by_driver) {where(driver_id: by_driver)}
  scope :by_start_date, -> (by_start_date) {where(start_time: by_start_date.to_date.all_day)}
  scope :by_end_date, -> (by_end_date) {where(end_time: by_end_date.to_date.all_day)}
  scope :by_ride_number, -> (by_ride_number) {where(ride_number: by_ride_number)}

  # callback
  after_commit :assign_ride_number, on: :create

  def assign_ride_number
    self.update(ride_number: self.id + 100)
  end

  def customer_trip
    if Customer.find(self.customer_id).cab_trips.where(status: ['confirmed', 'ongoing']).present?
      errors.add(:customer_id, "customer already has an ongoing trip cannot assign new")
    end
  end

  def self.assign_driver(params)
    status = true
    if params[:customer_mobile_number].present?
      customer = Customer.find_by(mobile_number: params[:customer_mobile_number])
      if customer.present?
        driver = Driver.active_driver(customer.customer_plan.rating_required).last
        if driver.present?
          cab_trip = CabTrip.new(customer_id: customer.id, driver_id: driver.id ,status: 'confirmed')
          if cab_trip.save
            driver.update(is_active: false)
            data = cab_trip
          else
            status = false
            data = []
            cab_trip.errors.each do |attribute, message|
              data << attribute.to_s + ' ' + message.to_s
            end
          end
        else
          status = false
          data = ["driver not available"]
        end
      else
        status = false
        data = ["customer not found"]
      end
    else
      status = false
      data = ["customer cannot be found without customer mobile number"]
    end
    return status, data
  end

  def self.calculate_fair(params)
    status = true
    if params[:cab_trip_id].present?
      cab_trip = CabTrip.find(params[:cab_trip_id])
      # verifing params required to calculate fair (surge, waiting_time can be 0 but is a required field)
      if  cab_trip.present? and cab_trip.status != 'cancelled' and cab_trip.status != 'completed' and params[:distance_travelled].present? and params[:surge].present? and params[:start_time].present? and params[:end_time].present? and params[:waiting_time].present? and params[:rate_per_km].present?
        params[:is_cancelled_after_start] == true ? (trip_status = 'cancelled'; is_cancelled_after_start = true) : (trip_status = 'completed'; is_cancelled_after_start = false)
        if cab_trip.update(distance_travelled: params[:distance_travelled], start_time: params[:start_time], end_time: params[:end_time], surge_amount: params[:surge], rate_per_km: params[:rate_per_km], waiting_time: params[:waiting_time].floor, status: trip_status, is_cancelled_after_start: is_cancelled_after_start)
          waiting_time = cab_trip.waiting_time
          travel_charge = cab_trip.distance_travelled*cab_trip.rate_per_km
          waiting_time > 4 ? waiting_charge = waiting_time*WAITING_PER_UNIT_TRAVEL_TIME : waiting_charge = 0
          travel_time_charge = ((cab_trip.start_time.to_datetime - cab_trip.end_time.to_datetime)*24*60).to_i*CHARGES_PER_UNIT_TRAVEL_TIME
          total_fair = BASE_FARE + travel_charge + travel_time_charge + waiting_charge
          cab_trip.update(total_fair: total_fair)
          cab_trip.driver.update(is_active: true)
          data = cab_trip
        else
          status = false
          data = []
          cab_trip.errors.each do |attribute, message|
            data << attribute.to_s + ' ' + message.to_s
          end
        end
      else
        status = false
        data = ["params not valid"]
      end
    else
      status = false
      data = ["params not valid"]
    end
    return status, data
  end

  # assumption variables are kept in global.rb
  def self.calculate_cancalled_trip_fair(params)
    status = true
    if params[:cab_trip_id].present?
      cab_trip = CabTrip.find(params[:cab_trip_id])
      if cab_trip.present? and params[:distance_travelled].blank? and params[:surge].blank? and params[:start_time].blank? and params[:end_time].blank? and params[:waiting_time].present? and params[:rate_per_km].blank?
        if cab_trip.update(waiting_time: params[:waiting_time].floor, status: 'cancelled', is_cancelled_before_start: true)
          cab_trip.waiting_time > 4 ? waiting_charge = CANCELLATION_CHARGE : waiting_charge = 0
          if cab_trip.update!(total_fair: waiting_charge)
            data = cab_trip
          else
            status = false
            data = ["params not valid"]
          end
        else
          status = false
          data = ["params not valid"]
        end
      else
        status = false
        data = ["params not valid"]
      end
    else
      status = false
      data = ["params not valid"]
    end
    return status, data
  end

end
