class AddTypeTeachingHours < ActiveRecord::Migration[5.1]
  def change
    add_column :teaching_hours, :individual, :boolean, default: false
  end
end
