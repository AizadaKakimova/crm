class AddDescriptionToCourses < ActiveRecord::Migration[5.1]
  def change
  	add_column :courses, :description, :text
  	add_column :courses, :image_link, :string
  end
end
