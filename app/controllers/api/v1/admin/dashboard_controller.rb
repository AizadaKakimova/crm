class Api::V1::Admin::DashboardController < ApplicationController
	before_action :authorize_access_request!, :set_admin_variables
  
  def index 
    @users = @users
    @requests = @requests
    render json: { users: @users, requests: @requests } 
  end

  def forbidden
  end
  
  def certificate
  end
  
  private
	def set_admin_variables
		#@categories = Category.visible
		#@cities = City.enabled
		@users = User.all.size
    @requests = Request.where(status: 'Новая').size
	end
end