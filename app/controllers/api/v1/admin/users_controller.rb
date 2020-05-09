class Api::V1::Admin::UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: [:show, :update, :destroy]
  VIEW_ROLES = %w[admin manager instructor student].freeze
  EDIT_ROLES = %w[admin].freeze

  def index
    @users = User.all
    @users = @users.search(params[:search])
    total = @users.size
    @users  = paginate @users
     render json: { users: @users, pagination: {
       current_page: @users.page(params[:page]).current_page, 
       next_page: @users.page(params[:page]).next_page, 
       prev_page: @users.page(params[:page]).prev_page, 
       total: total, last_page:  @users.page(params[:page]).total_pages, 
       to: @users.page(params[:page]).total_pages, from: 1
     }
    }
  end

  def show
    @enrollments = @user.enrollments
    @requests = @user.requests
    # @image_link = @user.image_link
    @groups = []
    for enrollment in @enrollments
      @groups.append(enrollment.group)
    end
    render json: { user: @user, enrollments: @enrollments, groups: @groups, requests: @requests}
  end
  def instructors
    @instructors = User.where(role: 'instructor')
    render json: @instructors
  end

  def create
    @user = User.new(user_params)
    @user.branch = current_user.branch
    @user.city = current_user.branch.city
    @user.password = params[:user][:phone]
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

  def destroy
    @user.destroy
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end
  def search
    p = params[:search]

    @users = User.where('users.created_at >= ?', Date.strptime(p[:start], "%d-%m-%y")) if p[:start].present?
    @users = @users.where('users.created_at <= ?', Date.strptime(p[:end], "%d-%m-%y")) if p[:end].present?
  end

  private

  def allowed_aud
    action_name == 'update' ? EDIT_ROLES : VIEW_ROLES
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role, :email, :phone, :password, :name, :school, :birthdate, :comment, :image_link)
  end
end
