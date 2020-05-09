class CraeteGroups < ActiveRecord::Migration[5.1]
  def change
  	create_table :groups do |t|
	    t.string   "title"
	    t.integer  "course_id"
	    t.integer  "instructor_id"
	    t.datetime "start"
	    t.datetime "end"
	    t.string   "slug"
		t.integer  "city_id"
      t.timestamps
    end
  end
end
