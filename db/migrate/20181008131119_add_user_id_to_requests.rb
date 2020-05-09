class AddUserIdToRequests < ActiveRecord::Migration[5.1]
  def change
  	add_column :requests, :user_id, :integer
  end
end
