class Api::V1::Student::GroupsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_group, only: [:show,:edit, :update, :destroy]
  #before_action :this_instructor, only: [:index]

  VIEW_ROLES = %w[user].freeze
  EDIT_ROLES = %w[user].freeze

  def index
    #@groups = Group.active.where(instructor_id: @instructor.id)
    @enrollments = Enrollment.where(user_id: current_user.id)
    @groups = Group.where(id:  @enrollments.pluck(:group_id))
    @courses = Course.where(id: @groups.pluck(:course_id))
    @instructors = User.find(@groups.pluck(:instructor_id))
    render json: { groups: @groups, courses: @courses, instructors: @instructors, enrollments: @enrollments}
  end

  def show
    @enrollments = @group.enrollments.by_coins
    @classmates = Enrollment.where(group_id: @group.id)
    # @classmates = @enrollments.pluck(:user_id)
    @students = @enrollments.pluck(:user_id)
    @students = User.find(@students)
    @users = User.find(@classmates.pluck(:user_id))
    @instructor = @group.instructor
    @course = @group.course
    render json: { group: @group, students: @students, instructor: @instructor, course: @course, enrollments: @enrollments}

  end

  def create
    @group = Group.new(group_params)
      if @group.save
        render json: @group
      else
        render json: @group.errors, status: :unprocessable_entity
      end
  end
  
  def update
    respond_to do |format|
      if @group.update(group_params)
        @group.create_activity :update, owner: current_user
        format.html { redirect_to admin_group_path(@group), warning: "Группа #{@group.title} обнавлена успешна." }
        format.json { respond_with_bip(@group) }
      else
        format.html { render :edit }
        format.json { respond_with_bip(@group) }
      end
    end
  end

  def add_coins
    @enrollment = Enrollment.find(params[:enrollment_id])
     if @enrollment.update(:coins => @enrollment.coins + params[:coins].to_f.round(2))
      #(@enrollment.coins + params[:coins].to_f).round(2)
        render json: @enrollment
     else
       render json: @enrollment.errors, status: :unprocessable_entity
     end
  end

  def minus_coins
    @enrollment = Enrollment.find(params[:enrollment_id])
     if @enrollment.update(:coins => @enrollment.coins - params[:coins].to_f.round(2))
      #(@enrollment.coins + params[:coins].to_f).round(2)
        render json: @enrollment
     else
       render json: @enrollment.errors, status: :unprocessable_entity
     end
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
    def set_group
      @group = Group.friendly.find(params[:id])
    end

    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end
    def group_params
      params.require(:group).permit(:title, :course_id, :city_id, :instructor_id, :start, :end, :slug)
    end
end
