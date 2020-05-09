class AddBranchToGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :branch_id, :integer
  end
end
