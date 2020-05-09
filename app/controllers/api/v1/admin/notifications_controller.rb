class Api::V1::Admin::NotificationsController < ApplicationController
  before_action :authorize_access_request!

  def index
    @notifications = Notification.status
    render json: @notifications
  end

end
