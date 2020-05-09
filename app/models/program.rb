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

class Program < ApplicationRecord

	belongs_to :course
	validates :title, presence: true
	validates :description, presence: true

end
