class CreatePayment < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
	    t.integer  "sum"
	    t.string   "comment"
	    t.integer  "enrollment_id"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.integer  "receiver_id"
	    t.integer  "course_id"
    end
  end
end
