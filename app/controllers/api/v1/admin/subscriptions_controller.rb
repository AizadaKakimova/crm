class Api::V1::Admin::SubscriptionsController < ApplicationController
	before_action :authorize_access_request!
	before_action :set_subscription, only: [:show, :edit, :update, :destroy]
	VIEW_ROLES = %w[admin manager].freeze
  ROLES = %w[admin manager].freeze

	def index
	
  @subscriptions = Subscription.all 

  render json: { subscriptions: @subscriptions}

  end


	def update
  
    if @cost.update(cost_params)
      render json: @cost
    else
      render json: { error: @course.errors.full_messages[0]}, status: :bad_request
    end
  end

	def create
    	@cost = Cost.new(cost_params)
	    if @cost.save
	    	render json: @cost
	    else
	        #render json:  @courses.errors, status: :unprocessable_entity
	        render json: { error: @cost.errors.full_messages[0]}, status: :bad_request
	    end
	end
	  
	def destroy
    @subscription.destroy
  end

	def set_subscription
    	@subscription = Subscription.find(params[:id])
  end

    def subscriptions_params
    	params.require(:subscription).permit(:email)
    end
end
