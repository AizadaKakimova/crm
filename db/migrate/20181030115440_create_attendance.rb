class CreateAttendance < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
    	t.integer  "enrollment_id"
    	t.datetime "day"
    end
  end
end
