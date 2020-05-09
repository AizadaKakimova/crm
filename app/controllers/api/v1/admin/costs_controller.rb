class Api::V1::Admin::CostsController < ApplicationController
	before_action :authorize_access_request!
	before_action :set_cost, only: [:show, :edit, :update, :destroy]
	VIEW_ROLES = %w[admin manager].freeze
  ROLES = %w[admin manager].freeze

	def index
	
  @costs = Cost.all 
  @user_name = @costs.pluck(:user_id)
  @user_name = User.find(@user_name).pluck(:id, :name)

  @expenses_by_month = @costs.group_by { |t| t.created_at.beginning_of_month}

  render json: { costs: @expenses_by_month, names: @user_name}

  end

	def show
    	render json: { cost: @cost } 
  	end

	def edit
  		@path = [:admin, @cost]
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
    @cost.destroy
  end

	def set_cost
    	@cost = Cost.find(params[:id])
  	end

    def cost_params
    	params.require(:cost).permit(:cost_name, :amount, :user_id, :fix)
    end
end
