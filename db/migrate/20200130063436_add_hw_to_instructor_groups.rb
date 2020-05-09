class AddHwToInstructorGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :hw, :string
  end
end
