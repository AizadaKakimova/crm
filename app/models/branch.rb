class Branch < ActiveRecord::Base
  acts_as_tenant(:city)
  #belongs_to :city
  has_many :requests
  has_many :users_branches
  has_many :groups
  has_many :payments
  has_many :users, through: :users_branches
end
