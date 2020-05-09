class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from JWTSessions::Errors::ClaimsVerification, with: :forbidden
  rescue_from ResetPasswordError, with: :not_authorized

  set_current_tenant_through_filter
  before_action :find_current_tenant

  def find_current_tenant
    # set to Account.first for now, you'll change this later
    #current_account = City.first
    current_account ||= City.find_by_slug(request.fullpath.split('/')[3])
    set_current_tenant(current_account)
  end

  

  private

  def current_user
    @current_user ||= User.find(payload['user_id'])
  end

  def admin?
    current_user and current_user.role == 'admin'
  end

  def manager?
    current_user and current_user.role == 'manager'
  end

  def instructor?
    current_user and current_user.role == 'instructor'
  end

  def bad_request
    render json: { error: 'Bad request' }, status: :bad_request
  end

  def forbidden
    render json: { error: 'Forbidden' }, status: :forbidden
  end

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end

  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { error: exception.record.errors.full_messages.join(' ') }, status: :unprocessable_entity
  end
end
