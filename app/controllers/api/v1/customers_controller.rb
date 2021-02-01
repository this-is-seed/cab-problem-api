module Api::V1
  class CustomersController < ApplicationController

    def index
      customers = Customer.filter(params.slice(:by_mobile_number, :by_name))
      data = ActiveModel::Serializer::CollectionSerializer.new(customers, serializer: CustomerSerializer, root: false)
      render json: {data: data, error: []}, status: :ok
    end

    def create
      customer = Customer.new(customer_params)
      if customer.save
        render json: {data: CustomerSerializer.new(customer, root: false), error: []}, status: :ok
      else
        data = []
        customer.errors.each do |attribute, message|
          data << attribute.to_s + ' ' + message.to_s
        end
        render json: {data: [], error: data}, status: :unprocessable_entity
      end
    end

    def update
      customer = Customer.find(customer_params[:id])
      if customer.present?
        if customer.update(customer_params)
          render json: {data: CustomerSerializer.new(customer, root: false), error: []}, status: :ok
        else
          data = []
          customer.errors.each do |attribute, message|
            data << attribute.to_s + ' ' + message.to_s
          end
          render json: {data: [], error: data}, status: :unprocessable_entity
        end
      else
        render json: {data: [], error: ["customer not found"]}, status: :unprocessable_entity
      end
    end

    private

    def customer_params
      params.require(:customer).permit(:id, :mobile_number, :full_name, :customer_plan_id)
    end

  end
end