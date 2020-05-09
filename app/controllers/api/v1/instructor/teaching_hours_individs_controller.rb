class Api::V1::Instructor::TeachingHoursIndividsController < ApplicationController
    before_action :authorize_access_request!
    before_action :set_instructor, only: [:index]
    before_action :teaching_params, only: [:create]
    def index
      @teaching_hours_individs = TeachingHoursIndivid.hours_this_month(params[:instructor_id])
     render json: { this_month: @teaching_hours_individs }
    end
    
    def create
      @teaching_hours_individs = TeachingHoursIndivid.new(teaching_params)
        if @teaching_hours_individs.save
          render json: @teaching_hours_individs
        else
          render json: @teaching_hours_individs.errors, status: :unprocessable_entity
        end
    end
  
    private
  
    def teaching_params
      params.require(:teaching_hours_individ).permit(:instructor_id, :hours)
    end
    
    def set_instructor
      @instructor = User.where(params[:instructor_id])
    end
  end