class City < ApplicationRecord
  has_many :requests
  has_many :groups
  has_many :enrollments, through: :groups
  has_many :payments, through: :enrollments
  has_many :courses
  has_many :expenses
  has_many :branches
  validates :name, presence: true
  validates :slug, presence: true

  default_scope -> {order('id ASC')}
  scope :enabled, -> {where(enabled: true)}
  
end
