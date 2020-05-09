class AddNewToNotifications < ActiveRecord::Migration[5.1]
  def change
  	add_column :notifications, :status, :boolean, default: true
  end
end
