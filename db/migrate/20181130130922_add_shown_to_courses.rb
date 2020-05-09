class AddShownToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :shown, :boolean
  end
end
