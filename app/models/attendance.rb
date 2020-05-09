class Attendance < ApplicationRecord
	belongs_to :enrollment

	validates_presence_of :day, :enrollment_id
end
