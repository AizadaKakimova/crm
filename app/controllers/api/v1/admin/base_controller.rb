# class BaseController < ApplicationController
# 	before_action :verify_admin, :set_sidebar
# 	layout 'admin'

# 	private
	
# 	def verify_admin
# 		unless current_user.try(:admin?) || new_subscription? || new_request?
# 	  	redirect_to root_url
# 	  end
# 	end

# 	def set_sidebar
# 		@sidebar = 'admin'
# 	end

# 	# def new_subscription?
# 	# 	params[:controller] == 'admin/subscriptions' && params[:action] == 'create'
# 	# end

# 	def new_request?
# 		params[:controller] == 'admin/requests' && params[:action] == 'create'
# 	end
# end