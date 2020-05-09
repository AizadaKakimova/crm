class Api::V1::Instructor::AttendancesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_enrollment, only: :show
  before_action :set_attendance, only: :destroy
  VIEW_ROLES = %w[admin instructor].freeze
  EDIT_ROLES = %w[instructor].freeze

  def show
    @attendances = @enrollment.attendances
    @user_name = User.find(@enrollment.user_id).name
    render json: {attendances: @attendances, enrollment: @enrollment, user_name: @user_name}
  end

  def create
    @attendence = Attendance.new(attendance_params)
      if @attendence.save
        render json: @attendence
      else
        render json: @attendence.errors, status: :unprocessable_entity
      end
  end

  def destroy
    @attendance.destroy
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

  def allowed_aud
    action_name == 'update' ? EDIT_ROLES : VIEW_ROLES
  end

  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  def attendance_params
    params.require(:attendance).permit(:day, :enrollment_id)
  end
end
