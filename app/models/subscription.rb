class Subscription < ApplicationRecord
	validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }
end
