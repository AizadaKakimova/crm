class Api::V1::Admin::SalariesController < ApplicationController
	before_action :authorize_access_request!, :set_salary, only: [:show, :update]


	def index
		@salaries = Salary.all
		render json: @salaries
	end

	def show
		render json: @salary
	end

	def create
		@salary = Salary.new(salary_params)
    if @salary.save
      render json: @salary
    else
        render json: @salary.errors.full_messages[0], status: :unprocessable_entity 
    end
	end
  def update
	  if @salary
	    @salary.update!(salary_params)
	    render json: @salary
	  else
	    render json: { error: 'Error' }, status: :bad_request
	  end
	end

	private 

	def set_salary
    @salary = Salary.find(params[:id])
  end

  def salary_params
    params.require(:salary).permit(:user_id, :monthly, :hourly,:role, :full_time)
  end

end