class Api::V1::Admin::GroupsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :reset_slug]
  VIEW_ROLES = %w[admin manager instructor student].freeze
  EDIT_ROLES = %w[admin].freeze

  def index
    @groups = Group.all
    course_ids = @groups.pluck(:course_id)
    @courses = Course.find(course_ids)
    @instructors = User.find(@groups.pluck(:instructor_id))

    @enrollments = {}
    for group in @groups
      @enrollments[group.slug] = group.enrollments.count
    end
    render json: { groups: @groups, enrollments: @enrollments,  instructors: @instructors, courses: @courses}
  end

  def show
    @enrollments_enrolled = @group.enrollments.enrolled
    @enrollments_dropped = @group.enrollments.dropped
    @enrollments_skipped = @group.enrollments.skipped
    @enrollments_attending = @group.enrollments.attending
    @enrollments_completed = @group.enrollments.completed
    @paid_days = {}
    @paid_amount = {}
    @paid_sum = {}
    @users = User.all
    @instructor = User.find(@group.instructor_id)
    @course_title = @group.course.title

    count_amount = 0
    count_paid = 0
    for enrollment in @enrollments_enrolled
      @paid_days[enrollment.id] = enrollment.paid_days
      @paid_amount[enrollment.id] = enrollment.expected_value
      @paid_sum[enrollment.id] = enrollment.paid
      count_amount += enrollment.expected_value
      count_paid += enrollment.paid
    end
    for enrollment in @enrollments_dropped
      @paid_days[enrollment.id] = enrollment.paid_days
      @paid_amount[enrollment.id] = enrollment.expected_value
      @paid_sum[enrollment.id] = enrollment.paid
      count_paid += enrollment.paid
    end
    for enrollment in @enrollments_attending
      @paid_days[enrollment.id] = enrollment.paid_days
      @paid_amount[enrollment.id] = enrollment.expected_value
      @paid_sum[enrollment.id] = enrollment.paid
      count_paid += enrollment.paid
    end
    for enrollment in @enrollments_skipped
      @paid_days[enrollment.id] = enrollment.paid_days
      @paid_amount[enrollment.id] = enrollment.expected_value
      @paid_sum[enrollment.id] = enrollment.paid
      count_paid += enrollment.paid
    end
    for enrollment in @enrollments_completed
      @paid_days[enrollment.id] = enrollment.paid_days
      @paid_amount[enrollment.id] = enrollment.expected_value
      @paid_sum[enrollment.id] = enrollment.paid
      count_paid += enrollment.paid
    end
    @overall_amount = count_amount
    @overall_paid = count_paid



     if params[:status].present?
      @enrollments = @group.enrollments.by_status(params[:status])
      render json: { enrollments: @enrollments, group: @group }
    else
      @enrollments = @group.enrollments
      render json: { enrollments: @enrollments, overall_paid: @overall_paid, overall_amount: @overall_amount, paid_days: @paid_days, paid_amount: @paid_amount, paid_sum: @paid_sum, group: @group,  enrollments_dropped: @enrollments_dropped, enrollments_enrolled: @enrollments_enrolled,
                     enrollments_completed: @enrollments_completed, enrollments_skipped: @enrollments_skipped, enrollments_attending: @enrollments_attending, instructor: @instructor, course_title: @course_title, users: @users}
    end
  end

  def create
    @group = Group.new(group_params)
    # @group.branch = current_user.branch
      if @group.save
        render json: @group
      else
        render json: @group.errors, status: :unprocessable_entity
      end
  end

  def update
      if @group.update(group_params)
        render json: @group
      # if else @group.update(params[:group_id])
      #   render json: @group
      else
        render json: { errors: @group.errors, status: bad_request}
      end
  end


  def destroy
      @group.destroy
  end

  def reset_slug
    @group.update(slug: nil)
    @group.update(id: nil)
  end

  def search
    p = params[:search]

    @groups = Group.where(Date.strptime(p[:start], "%d-%m-%y")) if p[:start].present?
    @groups = @groups.where(Date.strptime(p[:end], "%d-%m-%y")) if p[:end].present?
  end

  def send_params
    @group = Group.friendly.find(params[:group_id])

    add_breadcrumb @group.title, admin_group_path(@group) if @group
    add_breadcrumb "Отправка уведомлении", admin_group_send_sms_path

    if @group.city_id != @location.id
        redirect_to admin_forbidden_path
      end
    if params[:status].present?
      @enrollments = @group.enrollments.by_status(params[:status])
    else
      @enrollments = @group.enrollments.enrolled
    end
  end


  def send_sms_message
    # require 'rest_client'
    # phones = params[:group][:phones]
    # message = params[:group][:message]

    # number = phones
    # user = "ddagar"
    # password = ""
    # sender = "method.kz"
    # host = 'http://smsc.kz/sys/send.php'
    # message = message
    # charset = "utf-8"

    # response = RestClient.get host, { params: {
    #     login: user,
    #     psw: password,
    #     sender: sender,
    #     mes: message,
    #     phones: number,
    #     charset: charset
    #   }
    # }
    # redirect_to admin_group_send_sms_path, success: "Сообщения отправлены!"
    # rescue => e
    #   Rails.logger.debug "smsc.kz error"
    #   Rails.logger.debug e.message
    #   Rails.logger.debug e.backtrace
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

  def group_params
    #params[:group][:start] = DateTime.strptime(params[:group][:start],"%d-%m-%y")
    #params[:group][:end] = DateTime.strptime(params[:group][:end],"%d-%m-%y")
    params.require(:group).permit(:title, :course_id, :city_id, :instructor_id, :start, :time, :end, :slug, :branch_id, :id, :created_at, :updated_at, time: [], day: [])
  end
end
