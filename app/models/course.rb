# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  file_name   :string(255)
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Course < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
	acts_as_tenant(:city)
	validates :title, presence: true
	validates :description, presence: true
	validates :image_link, presence: true
	validates :price, presence: true
	validates :file_name, presence: true
	validates :duration, presence: true
	validates :level, presence: true
	validates :city_id, presence: true
	validates :slug, presence: true
	validates_uniqueness_of :slug
	has_many :program, dependent: :destroy
	has_many :requests
	has_many :groups

  before_save :set_slug
	default_scope {order('created_at ASC')}
	scope :visible, -> { where(visible: true) }

	def slug_candidates
		[
			[file_name.gsub('_', '-')],
			[id, file_name.gsub('_', '-')]
		]
	end

	def pretty_slug
		slug.capitalize
	end

	def set_slug
		self.slug ||= file_name.gsub('_', '-')
	end
end