class DriverSerializer < ActiveModel::Serializer
  attributes :id, :mobile_number, :full_name, :rides, :rating, :is_active

  def rides
    object.cab_trips.joins(:customer).select("cab_trips.*, customers.full_name")
  end
end
