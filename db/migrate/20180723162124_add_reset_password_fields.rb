class AddResetPasswordFields < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :reset_password_token, :string, default: nil
    add_column :users, :reset_password_token_expires_at, :datetime, default: nil
    add_index  :users, :reset_password_token
  end
end
