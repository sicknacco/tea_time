class Api::V0::SubscriptionsController < ApplicationController

  def create
    sub = Subscription.new(subscription_params)
    if sub.save
      render json: SubscriptionSerializer.new(sub), status: 201
    else
      render json: { error: sub.errors.full_messages.to_sentence }, status: 400
    end
  end

  def update
    sub = Subscription.find(params[:id])
    if sub[:status] == 'active'
      sub.update!(status: 'inactive')
      render json: SubscriptionSerializer.new(sub), status: 200
    else
      render json: { error: 'Subscription is already inactive' }, status: 400
    end
  end

  private
  
  def subscription_params
    params.permit(:title, :price, :status, :frequency, :customer_id, :tea_id)
  end
end