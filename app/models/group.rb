# == Schema Information
#
# Table name: groups
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  course_id     :integer
#  semester_id   :integer
#  instructor_id :integer
#  start         :datetime
#  end           :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class Group < ApplicationRecord
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged
	acts_as_tenant(:city)
	belongs_to :course
	belongs_to :instructor, class_name: 'User'
	belongs_to :branch
	validates_presence_of :course_id, :title, :instructor_id, :start, :end 
	has_many :enrollments, dependent: :destroy
	has_many :students, through: :enrollments, source: :user
	serialize :time, Array
	serialize :day, Array
	scope :by_instructor, -> {order('instructor_id ASC, course_id ASC, title ASC, start DESC')}
	scope :by_start_date, ->{order('start ASC')}
	scope :current, ->{where('start <= ? and "end" >= ?',Date.today,Date.today.beginning_of_day)}
	scope :next, ->{where('start > ?', Date.today)}
	scope :past, ->{where('"end" < ?', Date.today.beginning_of_day)}
	scope :active, ->{where('"end" >= ?', Date.today.beginning_of_day)}
	scope :branched, -> (current_user){ where(branch_id: current_user.branches.ids)}
	default_scope { order(start: :asc) }


	def slug_candidates
		[
			[title, start.strftime('%d-%b-%y')],
			[title, start.strftime('%d-%b-%y')],
			[id, title]
		]
	end
	def duration
		(self.end - self.start)/1.day
	end
	def group_enrollments
		e = self.enrollments
		{ enrolled: e.enrolled.count, dropped: e.dropped.count, skipped: e.skipped.count, attending: e.attending.count, completed: e.completed.count }
	end
	def phones
		phones = ""
		self.enrollments.enrolled.each do |enrollment|
			phones += enrollment.student.phone.gsub(/[^0-9,]/, '') + ","
		end
		phones
	end

	def expected_payments
		amount = 0
		enrollments.each do |enrollment|
			amount += enrollment.expected_value
		end
		amount
	end
end
