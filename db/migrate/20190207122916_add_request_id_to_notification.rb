class AddRequestIdToNotification < ActiveRecord::Migration[5.1]
  def change
  	add_column :notifications, :request_id, :integer
  end
end
