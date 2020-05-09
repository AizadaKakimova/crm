class Api::V1::Admin::TodosController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_todo, only: [:show, :update, :destroy]

  def index
    @todos = Todo.all
    @admins = User.where(role: 'admin')
    @managers = User.where(role: 'manager')
    @users = @admins + @managers
    render json: { todos: @todos, users: @users }
  end

  def show
    @todo = current_user.todos.find(params[:id])
    # @todo_newinprocess = @todo.todo.newinprocess
    # @todo_done = @todo.todo.done
      if params[:status].present?
        @todos = @todo.todos.by_status(params[:status])
        render json: { todo: @todo }
      else
        @todos = @todo.todos
        render json: {todo: @todo, todo_newinprocess: @todo_newinprocess, todo_done: @todo_done}
      end
    end

  def create
    @todo = current_user.todos.build(todo_params)
    if @todo.save
      render json: @todo_newtodo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :deadline, :status, :todo_maker, :todo_sender)
  end
end
