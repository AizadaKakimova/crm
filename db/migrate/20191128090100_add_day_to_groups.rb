class AddDayToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :day, :string
  end
end
