class AddBranchToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments,:branch_id,:integer
  end
end
