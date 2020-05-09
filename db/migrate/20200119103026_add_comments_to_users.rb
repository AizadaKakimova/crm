class AddCommentsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :comment, :string
  end
end
