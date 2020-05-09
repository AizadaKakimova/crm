class CreateEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollments do |t|
	    t.integer  "user_id"
	    t.integer  "group_id"
	    t.string   "status"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.string   "comment"
	    t.integer  "expected_value"
	    t.integer  "attend_days",    default: 0
	    t.date     "last_day"
	    t.float    "coins",          default: 10.0
  	end
  end
end
