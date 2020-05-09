class Api::V1::Admin::RequestsController < ApplicationController
  before_action :authorize_access_request!, except: :create
  before_action :set_request, only: [:show,:update, :destroy]

  VIEW_ROLES = %w[admin manager instructor user].freeze
  ROLES = %w[admin].freeze


  def index
    @requests = Request.all
    total = @requests.size
    @requests  = paginate @requests
    @branches = Branch.all
     render json: { branches: @branches,requests: @requests, pagination: {
       current_page: @requests.page(params[:page]).current_page, 
       next_page: @requests.page(params[:page]).next_page, 
       prev_page: @requests.page(params[:page]).prev_page, 
       total: total, last_page:  @requests.page(params[:page]).total_pages, 
       to: @requests.page(params[:page]).total_pages, from: 1
     }
    }
  end

  def show
    render json: @request
  end
    # POST /
  def create
    @request = Request.new(request_params)
    if @request.save
      @request.create_notification(message: @request.first.to_json)

    else
      render json: @request.errors, status: :bad_request
    end
  end

  def update
    if @request.update!(request_params)
      if @request.status != 'new' and @request.notification
        @notification = @request.notification
        @notification.update!(message: @request.to_json, status: false)
      end
      render json: @request
    else
      render json: { error: 'Ошибка обработке'}, status: :bad_request
    end
  end

  def destroy
    render json: @request.destroy
  end

  def token_claims
    {
      aud: ROLES,
      verify_aud: true
    }
  end

  private

  private
    def set_request
      @request = Request.find(params[:id])
    end

    def request_params
      params.require(:request).permit(:name, :phone, :email, :time, :message, :info, :status, :source, :user_id, :course_id, :branch_id)
    end
end
