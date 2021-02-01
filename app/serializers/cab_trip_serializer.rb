class CabTripSerializer < ActiveModel::Serializer
  attributes :id, :ride_number, :customer_name, :driver_name, :distance_travelled, :is_cancelled_before_start,
             :is_cancelled_after_start, :rating, :travel_time, :start_time, :end_time, :waiting_time,
             :rate_per_km, :surge_amount, :status, :total_fair

  def customer_name
    object.customer.full_name
  end

  def driver_name
    object.driver.full_name
  end

  def travel_time
    if object.start_time.present? and object.end_time.present?
      ((object.end_time.to_datetime - object.start_time.to_datetime)*24*60).to_i
    end
  end
end
