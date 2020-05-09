class Payment < ApplicationRecord
	
	acts_as_tenant(:city)
	belongs_to :enrollment
	validates_presence_of :sum, :enrollment_id, :receiver_id, :course_id
	delegate :student, to: :enrollment, allow_nil: true
	
	scope :branched, -> (current_user){ where(branch_id: current_user.branches.ids)}

	def self.payment_list
  		pay_list = []
  		payments = Payment.all
  		payments.each do |pay|
    		pay_info = pay.attributes
    		pay_info[:receiver] = User.find(pay.receiver_id).name
    		enroll = Enrollment.find(pay.enrollment_id).user_id
    		pay_info[:sender] = User.find(enroll).name
    		pay_list << pay_info
  		end
  		pay_list
	end

  def self.search(search)
    if search
      search = search.mb_chars.downcase.to_s
      where('lower(receiver) LIKE ? OR lower(sender) LIKE ?'  ,"%#{search}%",  "%#{search}%")
    else
      all
    end
  end

	default_scope { order(created_at: :desc) }
end
