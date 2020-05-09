class AddTimeToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :time, :string
  end
end
