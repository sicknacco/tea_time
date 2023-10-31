class Api::V0::SubscriptionsController < ApplicationController
  def create
    sub = Subscription.new(subscription_params)
    if sub.save
      render json: SubscriptionSerializer.new(sub), status: 201
    else
      "sad path"
    end
  end

  private
  
  def subscription_params
    params.permit(:title, :price, :status, :frequency, :customer_id, :tea_id)
  end
end