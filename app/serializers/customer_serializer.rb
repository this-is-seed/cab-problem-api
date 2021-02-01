class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :mobile_number, :plan, :full_name, :rides

  def rides
    object.cab_trips.joins(:driver).select("cab_trips.*, drivers.full_name")
  end

  def plan
    object.customer_plan.name
  end
end
