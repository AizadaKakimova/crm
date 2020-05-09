class Api::V1::Instructor::DashboardController < ApplicationController
	before_action :authorize_access_request!, :set_admin_variables
  
  def index 
   render json: {}
  end

  def forbidden
  end
  
  def certificate
  end
  
  private
	def set_admin_variables
	
	end
end