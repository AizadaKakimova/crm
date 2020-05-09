class Request < ApplicationRecord
	STATUSES = {pending: 'В процессе', processed: 'Обработана', new: 'Новая', enrolled: 'В группе'}
	validates :status, presence: true, inclusion: STATUSES.values
	acts_as_tenant(:city)
  # validates :email,
  #         format: { with: URI::MailTo::EMAIL_REGEXP },
  #         presence: true,
  #         uniqueness: { case_sensitive: false }
  validates :phone, presence: true
	SOURCES = {sem: 'Поисковик', smm: 'Соц сети', recommendation: 'Рекомендация', newsletter: 'Рассылка', other: 'Другое', billboard: "Биллбоард"}
	#validates :source, presence: true, inclusion: SOURCES.values
	validates :name, presence: true
	validates :city_id, presence: true
	belongs_to :branch
	has_one :user
	# validate :branch_id
	#belongs_to :notification, required: false
	has_one :notification, dependent: :destroy
	default_scope { order('requests.created_at DESC') }
	scope :recent, lambda{where(['created_at > ?', 30.days.ago]) }
	scope :notify, -> {where("created_at >=?" ,3.days.ago).where(status: 'new')}
	scope :pending, -> {where(status: 'pending')}
	scope :requests_today, -> {where("created_at >=?" ,1.days.ago)}
	scope :enrolled, -> {where(status: 'enrolled')}
	scope :processed, -> {where(status: 'processed')}
	scope :branched, -> (current_user){ where(branch_id: current_user.branches.ids)}

	#Start for the scopes of the requests
	scope :by_course_id, ->(course_id){includes(:course).where("courses.id"=>course_id)}					 #adding keyword for the "Основы программирования"

	# after_commit :send_confirmation_message, on: :create

	def self.search(search)
	  if search
	  	search = search.mb_chars.downcase.to_s
	    where('lower(phone) LIKE ? OR lower(name) LIKE ?'  ,"%#{search}%",  "%#{search}%")
	  else
	    all
	  end
	end

	def self.statuses
		STATUSES
	end

	def self.cities
		City.all
	end

	def self.sources
		SOURCES
	end

	def to_user
		{name: name, phone: phone}
	end

	def date_name
		created_at.try(:to_i) || Time.zone.now.to_i
	end

	def short_slug
		slug[-4..-1]
	end

	# def send_confirmation_message
	#     require 'rest_client'

	#     number = phone.gsub(/[^0-9,]/, '')
	#     user = "ddagar"
	#     password = "d3242777"
	#     sender = "method.kz"
	#     host = 'http://smsc.kz/sys/send.php'
	#     message = "#{name.capitalize}, ваша заявка принята. Спасибо!"
	#     charset = "utf-8"

	#     response = RestClient.get host, { params: {
	#         login: user,
	#         psw: password,
	#         sender: sender,
	#         mes: message,
	#         phones: number,
	#         charset: charset
	#       }
	#     }

	#   rescue => e
	#     Rails.logger.debug "smsc.kz error"
	#     Rails.logger.debug e.message
	#     Rails.logger.debug e.backtrace
	#  end
end
