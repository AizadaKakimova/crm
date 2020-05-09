class Api::V1::RequestsController < ApplicationController
  
  def create
    @request = Request.new(request_params)
    if @request.save
      @request.create_notification(message: @request.to_json)
      render json: {}, status: :created
    else
      render json: @request.errors, status: :bad_request
    end
  end



  private

    def request_params
      params.require(:request).permit(:name, :phone, :email, :message, :info, :source, :branch_id, :course_id)
    end
end
