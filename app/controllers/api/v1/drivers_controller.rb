module Api::V1
  class DriversController < ApplicationController

    def index
      drivers = Driver.filter(params.slice(:by_name, :by_mobile_number))
      data = ActiveModel::Serializer::CollectionSerializer.new(drivers, serializer: DriverSerializer, root: false)
      render json: {data: data, error: []}, status: :ok
    end

    def create
      driver = Driver.new(driver_params)
      if driver.save
        render json: {data: DriverSerializer.new(driver, root: false), error: []}, status: :ok
      else
        data = []
        driver.errors.each do |attribute, message|
          data << attribute.to_s + ' ' + message.to_s
        end
        render json: {data: [], error: data}, status: :unprocessable_entity
      end
    end

    def update
      driver = Driver.find(driver_params[:id])
      if driver.present?
        if driver.update(driver_params)
          render json: {data: DriverSerializer.new(driver, root: false), error: []}, status: :ok
        else
          data = []
          driver.errors.each do |attribute, message|
            data << attribute.to_s + ' ' + message.to_s
          end
          render json: {data: [], error: data}, status: :unprocessable_entity
        end
      else
        render json: {data: [], error: ["driver not found"]}, status: :unprocessable_entity
      end
    end

    private

    def driver_params
      params.require(:driver).permit(:id, :mobile_number, :full_name)
    end

  end
end