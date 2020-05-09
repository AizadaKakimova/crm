class CreateTeachingHoursIndivids < ActiveRecord::Migration[5.1]
  def change
    create_table :teaching_hours_individs do |t|
      t.integer  "instructor_id"
    	t.float    "hours",         default: 0.0

      t.timestamps
    end
  end
end
