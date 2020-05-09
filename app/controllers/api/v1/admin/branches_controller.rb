class Api::V1::Admin::BranchesController < ApplicationController
	before_action :authorize_access_request!, except: :show
	before_action :set_branch, only: [:show, :edit, :update, :destroy]
	VIEW_ROLES = %w[admin manager].freeze
	ROLES = %w[admin manager].freeze

	def index	
  		@branches = Branch.all
  		render json: { branches: @branches}
  	end

	def show
    	render json: { branch: @branch } 
  	end

	def edit
  		@path = [:admin, @branch]
	end

	def update
		if @branch.update(branch_params)
			render json: @branch
		else
			render json: { error: @branch.errors.full_messages[0]}, status: :bad_request
		end
	end

	def create
    	@branch = Branch.new(branch_params)
	    if @branch.save
	    	render json: @branch
	    else
	        #render json:  @courses.errors, status: :unprocessable_entity
	        render json: { error: @branch.errors.full_messages[0]}, status: :bad_request
	    end
	end
	  
	def destroy
    	@branch.destroy
  	end

	def set_branch
    	@branch = Branch.find(params[:id])
  	end

    def branch_params
    	params.require(:branch).permit(:name, :address)
    end
end
