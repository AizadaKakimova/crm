class Api::V1::Admin::EnrollmentsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_enrollment, only: [:show, :edit, :update, :destroy]
  before_action :set_group, only: [:new, :create]


  def index
    @enrollments = Enrollment.all
    render json: @enrollments
  end

  def show
    @payments = @enrollment.payments
    @paid = @payments.sum(:sum)
    @left = @enrollment.expected_value - @paid
    @paid_days = @enrollment.paid_days
    @enrolled_user = @enrollment.user
    @receivers = @payments.pluck(:receiver_id)
    @course_id = @group.course_id
    @receivers = User.find(@receivers)
    render json: {course_id: @course_id, enrollment: @enrollment, payments: @payments, paid: @paid, left: @left, paid_days: @paid_days, enrolled_user: @enrolled_user, receivers: @receivers}
  end

  def new
    @enrollment = Enrollment.new
    @path = [:admin, @group, @enrollment]
  end

  def edit
    @path = [:admin, @enrollment]
    add_breadcrumb "Редактирование", ""
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    if @enrollment.save
      render json: @enrollment
    else
      render json: @enrollment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @enrollment.update(enrollment_params)
      render json: @enrollment
    else
      render json: @enrollment.errors
    end
  end

  def destroy
    @enrollment.destroy
  end


  private
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
      @group = @enrollment.group
    end

    def set_group
      @group = Group.friendly.find(params[:group_id])
    end

    def enrollment_params
      params.require(:enrollment).permit(:user_id, :group_id, :status, :comment, :expected_value, :attend_days,:coins, :created_at, :updated_at, :last_day, :id)
    end

end
