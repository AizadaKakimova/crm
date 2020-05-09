class Api::V1::Admin::TeachingHoursController < ApplicationController
  before_action :authorize_access_request!
  before_action :teaching_params, only: [:create]
  VIEW_ROLES = %w[admin manager instructor student].freeze
  EDIT_ROLES = %w[instructor].freeze

  def index
      @teachers = User.where(instructor: true).order('name DESC').includes(:teaching_hours,:groups)
      render json: @teachers
  end
    
  def create
  	@teaching_hours = TeachingHours.new(teaching_params)
      if @teaching_hours.save
        render json: @teaching_hours
      else
        render json: @teaching_hours.errors, status: :unprocessable_entity
      end
  end

  private

   def teaching_params
    params.require(:teaching_hours).permit(:instructor_id, :group_id, :hours)
  end
end