# == Schema Information
#
# Table name: enrollments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  group_id   :integer
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Enrollment < ApplicationRecord

	belongs_to :user
	belongs_to :group
	has_many :payments
	has_many :attendances

	STATUSES = {enrolled: 'enrolled', attending: 'attending', completed: 'completed',
		dropped: 'dropped', skipped: 'skipped'}

	validates :status, presence: true, inclusion: STATUSES.values
	validates_uniqueness_of :user_id, :scope => [:group_id]
	validates_presence_of :user_id, :group_id, :expected_value
	validates_presence_of :user, :group

	alias_attribute :student, :user

	scope :by_status, -> status { where(status: status) if status.present? }
	scope :enrolled, -> { where(status: 'enrolled') }
	scope :dropped, -> { where(status: 'dropped') }
	scope :skipped, -> { where(status: 'skipped') }
	scope :attending, -> { where(status: 'attending') }
	scope :completed, -> { where(status: 'completed') }
	scope :by_name , -> { order('id ASC')}
	scope :by_coins , -> { order('coins DESC')}
	def self.statuses
		STATUSES
	end

	def set_default_expected_value
		self.expected_value = course.try(:price)
	end

	def paid
		payments.sum(:sum)
	end

	def name_of_user

	end

	def paid_days
		return 0 if expected_value - payments.sum(:sum) == 0
		days_from_start = (Time.now - group.start)/1.day
		price_per_day = expected_value/group.duration
		if group.duration.to_i == 0
			return 0 
		else
			p = ((paid - price_per_day*days_from_start)/price_per_day)
			return p.to_i
		end
	end

end
