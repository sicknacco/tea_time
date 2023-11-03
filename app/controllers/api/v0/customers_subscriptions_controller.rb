class Api::V0::CustomersSubscriptionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_record
  def index
    customer = Customer.find(params[:customer_id])
    render json: SubscriptionSerializer.new(customer.subscriptions)
  end

  private

  def invalid_record(error)
    render json: { error: error.message }, status: 404
  end
end