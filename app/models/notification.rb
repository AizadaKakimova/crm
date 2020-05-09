class Notification < ApplicationRecord
  after_create_commit :send_notification
  	
	belongs_to :request
  scope :status, -> {where(status: true)}

  private

  def send_notification
  	ActionCable.server.broadcast "notifications", self.to_json
  end

end
