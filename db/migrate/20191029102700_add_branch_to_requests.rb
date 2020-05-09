class AddBranchToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :branch_id, :integer
  end
end
