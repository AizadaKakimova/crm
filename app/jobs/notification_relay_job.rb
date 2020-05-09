class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(notification)

  end
end
