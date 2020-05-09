class Api::V1::SubscriptionsController < ApplicationController

	def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      
      render json: {}, status: :created
    else
      render json: @subscription.errors, status: :bad_request
    end
  end

  private
    def subscription_params
      params.require(:subscription).permit(:email)
    end
end