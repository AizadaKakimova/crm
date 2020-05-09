class Api::V1::Instructor::TeachingHoursController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_instructor, only: [:index]
  before_action :teaching_params, only: [:craete]
  def index
    @teaching_hours = TeachingHour.hours_this_month(params[:instructor_id])
    @invdividual_hours_this_month = TeachingHour.invdividual_hours_this_month(params[:instructor_id])
   render json: { teaching_hours: @teaching_hours, teaching_hours_individs: @invdividual_hours_this_month }
  end
  
  def create
    @teaching_hours = TeachingHour.new(teaching_params)
      if @teaching_hours.save
        render json: @teaching_hours
      else
        render json: @teaching_hours.errors, status: :unprocessable_entity
      end
  end

  private

  def teaching_params
    params.require(:teaching_hour).permit(:instructor_id, :group_id, :hours)
  end
  
  def set_instructor
    @instructor = User.where(params[:instructor_id])
  end
end