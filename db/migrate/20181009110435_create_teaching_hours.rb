class CreateTeachingHours < ActiveRecord::Migration[5.1]
  def change
    create_table :teaching_hours do |t|
    	t.integer  "instructor_id"
    	t.integer "group_id"
    	t.float    "hours",         default: 0.0

    	t.timestamps
    end
  end
end
