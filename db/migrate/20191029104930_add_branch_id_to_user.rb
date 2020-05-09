class AddBranchIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :branch_id, :integer
  end
end
