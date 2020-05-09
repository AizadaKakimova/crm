class Salary < ApplicationRecord
	belongs_to :user
	validates_presence_of :user_id, :monthly, :hourly
end