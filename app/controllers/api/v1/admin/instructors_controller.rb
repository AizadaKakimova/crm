class Api::V1::Admin::InstructorsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: [:show, :update, :destroy]
  VIEW_ROLES = %w[admin manager instructor student].freeze
  EDIT_ROLES = %w[admin].freeze

  def index
    @instructors = User.where(role: 'instructor')
    @group_ids = []
    @teaching_hours = {}
    @salaries = {}
    # @image_link = @instructors.image_link
    
    for instructor in @instructors
      @group_ids[instructor.id] = instructor.group_ids.count
    end
    for instructor in @instructors
      @teaching_hours[instructor.id] = TeachingHour.hours_this_month(instructor.id)   
    end
    for instructor in @instructors
        @salaries[instructor.id] = Salary.where(user_id: instructor.id)
    end
    render json: { instructors: @instructors, group_ids: @group_ids, teaching_hours: @teaching_hours, salaries: @salaries} 
  end

  def show
    # @image_link = @instructor.image_link
    @groups = Group.where(instructor_id: @instructor.id)
    @teaching_hours = TeachingHour.hours_this_month(@instructor.id)
    @salary = Salary.where(user_id: @instructor.id).first
    @enrollments = {}
    for group in @groups 
      @enrollments[group.id] = group.group_enrollments
    end
    render json: { instructor: @instructor, enrollments: @enrollments, groups: @groups, teaching_hours: @teaching_hours, salary: @salary} 
  end

  def create
    @instructor = User.new(user_params)
    @instructor.password = params[:user][:email]
    if @instructor.save
      render json: @instructor
    else
        render json:  @instructor.errors, status: :unprocessable_entity 
    end
  end


  def update
    if @instructor
      @instructor.update!(user_params)
      #JWTSessions::Session.new(namespace: "user_#{@instructor.id}").flush_namespaced_access_tokens
      render json: @instructor
    else
      render json: { error: 'Admin cannot modify their own role' }, status: :bad_request
    end
  end

  def destroy
    @instructor.destroy
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

  def set_user
    @instructor = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role, :email, :phone, :password, :name, :school, :birthdate, :image_link)
  end
end