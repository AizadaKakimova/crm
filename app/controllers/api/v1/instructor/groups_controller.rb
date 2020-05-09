class Api::V1::Instructor::GroupsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_group, only: [:show,:edit, :update, :destroy]
  #before_action :this_instructor, only: [:index]

  VIEW_ROLES = %w[admin instructor].freeze
  EDIT_ROLES = %w[instructor].freeze

  def index
    #@groups = Group.active.where(instructor_id: @instructor.id)
    @groups = Group.active.where(instructor_id: current_user.id)
    render json: { groups: @groups }
  end

  def show
    @user = User.find(@group.instructor_id)
    @enrollments_enrolled = @group.enrollments.enrolled.by_coins
    @course_title  = @group.course.title
    @students = @enrollments_enrolled.pluck(:user_id)
    @students = User.find(@students)
    @enrollments = @enrollments_enrolled.pluck(:id)
    @attendance = Attendance.where(enrollment_id: @enrollments).group_by(&:enrollment_id)
    render json: { enrollments: @enrollments_enrolled, group: @group, students: @students, instructor: @user, enrollments_enrolled: @enrollments_enrolled, course_title: @course_title, attendance: @attendance }
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
    # respond_to do |format|
      # if @group.update(group_params)
      #   @group.create_activity :update, owner: current_user
      #   format.html { redirect_to admin_group_path(@group), warning: "Группа #{@group.title} обнавлена успешна." }
      #   format.json { respond_with_bip(@group) }
      # else
      #   format.html { render :edit }
      #   format.json { respond_with_bip(@group) }
      # end
    # end
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
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

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  def create_item
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
    # item = Item.create item_params
    # Attach picture to our item, if available
    # attach_main_pic(item) if admin_params[:picture].present?

    # Reply with success if the object was saved, or failure if it was not.
    # if item.persisted?
    #   render json: item, status: 200
    # else
    #   render json: item, status: 400
    # end
  end


  

  private
    def attach_main_pic(item)
      item.picture.attach(admin_params[:picture])
    end

    def item_params
      {
        name: admin_params[:name],
        # description: admin_params[:description],
      }
    end

    def admin_params
      params.permit(
        :picture
      )
    end
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
      params.require(:group).permit(:title, :course_id, :city_id, :instructor_id, :start, :end, :slug, :hw)
    end
end
