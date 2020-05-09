class Api::V1::Admin::PaymentsController < ApplicationController
	before_action :authorize_access_request!
  	before_action :set_user, only: [:show, :update, :destroy]
  	VIEW_ROLES = %w[admin manager].freeze
  	EDIT_ROLES = %w[admin].freeze
	
	def index
		@course_title = Course.all.select(:title, :id)

		@payments_all = Payment.all
	    @payments = Payment.search(params[:search])
	    total = @payments.count
	    @total_payment = @payments.sum(&:sum)
	    @payments  = paginate @payments
	     render json: { payments: @payments_all,  course_name: @course_title, pagination: {
	       current_page: @payments.page(params[:page]).current_page, 
	       next_page: @payments.page(params[:page]).next_page,
	       prev_page: @payments.page(params[:page]).prev_page, 
	       total: total, last_page:  @payments.page(params[:page]).total_pages, 
	       to: @payments.page(params[:page]).total_pages, from: 1
	     },
	     total_payment: @total_payment
	    }
	end

	def create
		@payment = Payment.new(payment_params)
		@payment.branch_id = Enrollment.find(payment_params[:enrollment_id]).group.branch.id
	    if @payment.save
	    	render json: @payment
	    else
	        #render json:  @courses.errors, status: :unprocessable_entity
	        render json: { error: @payment.errors.full_messages[0]}, status: :bad_request
	    end
	end

	def search
 		p = params[:search]

    	@payments = Payment.where('payments.created_at >= ?', Date.strptime(p[:start], "%d-%m-%y")) if p[:start].present?
    	@payments = @payments.where('payments.created_at <= ?', Date.strptime(p[:end], "%d-%m-%y")) if p[:end].present?
  	end

    private

    def set_user
    	@payment = Payment.find(params[:id])
  	end

    def payment_params
    	params.require(:payment).permit(:sum, :enrollment_id, :receiver_id, :course_id, :comment)
    end
end
