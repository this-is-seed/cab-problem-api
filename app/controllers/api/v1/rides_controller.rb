module Api::V1
  class RidesController < ApplicationController

    def index
      trips = CabTrip.filter(params.slice(:by_customer, :by_driver, :by_start_date, :by_end_date, :by_ride_number))
      data = ActiveModel::Serializer::CollectionSerializer.new(trips, serializer: CabTripSerializer, root: false)
      render json: {data: data, error: []}, status: :ok
    end

    def create
      status, data = CabTrip.assign_driver(params)
      if status
        render json: {data: CabTripSerializer.new(data, root: false), error: []}, status: :ok
      else
        render json: {data: [], error: data}, status: :unprocessable_entity
      end
    end

    def update
      # cancelled rides should only have params related to cancellation to avoid abnormal data
      is_cancelled_before_start = (params[:is_cancelled_before_start].present? and params[:is_cancelled_before_start] == true and params[:is_cancelled_after_start].blank?)
      is_cancelled_after_start = (params[:is_cancelled_after_start].present? and params[:is_cancelled_after_start] == true and params[:is_cancelled_before_start].blank?)
      not_cancelled = (params[:is_cancelled_before_start].blank? and params[:is_cancelled_after_start].blank?)

      # if cancelled before start total fair is based on waiting time
      if is_cancelled_before_start
        status, data = CabTrip.calculate_cancalled_trip_fair(params)
      # if cancelled during an ongoing ride fair is calculated as a normal completed ride so calculation kept in same method
      elsif is_cancelled_after_start or not_cancelled
        status, data = CabTrip.calculate_fair(params)
      else
        status, data = false, ["invalid input"]
      end
      if status
        render json: {data: CabTripSerializer.new(data, root: false), error: []}, status: :ok
      else
        render json: {data: [], error: data}, status: :unprocessable_entity
      end
    end

    def rate_driver
      if params[:cab_trip_id].present? and params[:rating].present?
        rating = params[:rating].to_f
        cab_trip = CabTrip.find(params[:cab_trip_id])
        if cab_trip.present? and cab_trip.status == 'completed' and rating >= 0 and rating <= 5
          cab_trip.update(rating: rating)
          Driver.calculate_rating(cab_trip.driver_id)
          render json: {data: ["Thanks for riding with us"], error: []}, status: :ok
        else
          render json: {data: [], error: ["invalid params"]}, status: :unprocessable_entity
        end
      else
        render json: {data: [], error: ["invalid params"]}, status: :unprocessable_entity
      end
    end

  end
end