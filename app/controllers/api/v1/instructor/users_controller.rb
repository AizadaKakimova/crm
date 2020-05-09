class Api::V1::Instructor::UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: [:show, :update]
  VIEW_ROLES = %w[admin instructor].freeze
  EDIT_ROLES = %w[admin].freeze

  def index 
    group = Group.active.find_by(slug: params[:group_slug])
    @enrollments = Enrollment.where(group_id: group.id )

    @users = User.find(@enrollments.pluck(:user_id))
    if group.instructor_id == current_user.id && current_user.instructor?
      render json: @users
    else
      render json: :forbidden
    end
  end
  def show
    @enrollments ||= @user.enrollments
    @groups = []
    for enrollment in @enrollments
      @groups.append(enrollment.group)
    end
    render json: { user: @user, enrollments: @enrollments, groups: @groups }
  end
  def instructors
    @instructors = User.where(role: 'instructor')
    render json: @instructors
  end

  def create
    @user = User.new(user_params)
    @user.password = params[:user][:email]
    if @user.save
      render json: @user
    else
        render json:  @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user
      @user.update!(user_params)
      #JWTSessions::Session.new(namespace: "user_#{@user.id}").flush_namespaced_access_tokens
      render json: @user
    else
      render json: { error: 'Admin cannot modify their own role' }, status: :bad_request
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

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role, :email, :phone, :password, :name, :school, :birthdate, :image_link)
  end
end
