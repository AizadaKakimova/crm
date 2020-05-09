class Api::V1::Admin::ProgramController < ApplicationController
    before_action :authorize_access_request!
    before_action :set_program, only: [:show, :edit, :update, :destroy]
    # before_action :set_program, only: [:new, :create]
  
    def index
      @program = Program.all
      render json: {program: @program}
    end
  
    def show
      @title = @program.title
      @description = @program.description
      @number = @program.number
      @course_id = @course.id
      render json: {number: @number, course_id: @course_id, title: @title, description: @description}
    end
  
    def new
      @program = Program.new
      @path = [:admin, @course, @program]
    end
  
    def edit
      @path = [:admin, @program]
      add_breadcrumb "Редактирование", ""
    end
  
    def create
      @program = Program.new(program_params)
      if @program.save
        render json: @program
      else
        render json: @program.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @program.update(program_params)
        render json: @program
      else
        render json: @program.errors
      end
    end
  
    def destroy
      @program.destroy
    end
  
  
    private
      def set_program
        @program = Program.find(params[:id])
        @course = @program.course
      end
  
      def set_course
        @course = Course.find(params[:id])
      end
  
      def program_params
        params.require(:program).permit(:number, :course_id, :title, :description)
      end
  
  end
  