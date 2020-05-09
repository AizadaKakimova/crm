class Api::V1::Student::DashboardController < ApplicationController
  before_action :authorize_access_request!, :set_student_variables

  def index
    @classmates = Enrollment.where(id: @groups.pluck(:id))
    @users = User.find(@classmates.pluck(:user_id))
    render json: {enrollments: @enrollments, groups: @groups, students: @users, classmates: @classmates}
  end

  def forbidden
  end

  def certificate
  end

  private

  def set_student_variables
    #@categories = Category.visible
    #@cities = City.enabled
    @enrollments = Enrollment.where(user_id: current_user.id)
    @groups = Group.where(id:  @enrollments.pluck(:group_id))
  end
end