class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  acts_as_tenant(:city)
  has_secure_password
  has_many :todos
  has_many :groups, foreign_key: 'instructor_id'
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :requests
  has_many :teaching_hours, foreign_key: 'instructor_id'
  has_one :salary
  has_many :costs
  has_many :users_branches
  belongs_to :branch
  has_many :branches, through: :users_branches
  validates_presence_of :name
  validates :phone, presence: true, uniqueness: true
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }
  enum role: %i[user manager admin instructor].freeze
  scope :instructors, -> {where(role: 'instructor')}
  scope :branched, -> (current_user){ where(branch_id: current_user.branches.ids)}
  default_scope {order('id DESC')}
  before_save { self.email = email.downcase }
  

  def attributes
    {id: id, email: email, role: role, name: name, phone: phone, school: school, birthdate: birthdate, created_at: created_at}
  end

  def admin?
    @current_user & @current_user.role == 'admin'
  end

  def super_user?
    if SuperUser.find_by(user_id: self.id)
      return true
    else
      return false
    end
  end  
  def manager?
    @current_user & @current_user.role == 'manager'
  end

  def self.search(search)
    if search
      search = search.mb_chars.downcase.to_s
      where('lower(phone) LIKE ? OR lower(name) LIKE ?'  ,"%#{search}%",  "%#{search}%")
    else
      all
    end
  end

  def hours
    teaching_hours.sum(:hours)
  end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)
    self.reset_password_token_expires_at = 1.day.from_now
    save!
  end

  def clear_password_token!
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
    save!
  end
end
