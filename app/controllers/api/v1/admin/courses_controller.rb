  class Api::V1::Admin::CoursesController < ApplicationController
  before_action :authorize_access_request!, except: :show
  before_action :set_course, only: [:show, :edit, :update, :destroy, :reset_slug]
  VIEW_ROLES = %w[admin manager].freeze
  ROLES = %w[admin manager].freeze

  def index
  @courses = Course.all
  @branches = Branch.all
  @program = Program.all
  render json: {courses: @courses, branches: @branches, program: @program}
  end

  def show
  render json: { course: @course }
  end

  def edit
  @path = [:admin, @course]
  end


  def create
    @course = Course.new(course_params)
    if @course.save
      render json: @course
    else
        #render json:  @courses.errors, status: :unprocessable_entity
        render json: { error: @course.errors.full_messages[0]}, status: :bad_request
    end
  end

  def update
      if @course.update(course_params)
        render json: @course
      else
        render json: { error: @course.errors.full_messages[0]}, status: :bad_request
      end
  end

  def destroy
    @course.destroy
  end

  def reset_slug
  @course.update(slug: nil)
  @course.update(id: nil)
    #redirect_to :back
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :file_name, :price, :slug, :visible, :shown,:duration,:level, :description, :image_link)
  end

  end
