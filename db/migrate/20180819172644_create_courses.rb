class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
    	t.string   "title"
	    t.string   "file_name"
	    t.integer  "price",       default: 0
	    t.string   "slug"
	    t.boolean  "visible",     default: true
	    t.integer  "city_id",     default: 1

      t.timestamps
    end
  end
end
