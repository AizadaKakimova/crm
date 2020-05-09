class CreateSalaries < ActiveRecord::Migration[5.1]
  def change
    create_table :salaries do |t|
    	t.integer  "user_id"
    	t.integer "monthly", default: 0
    	t.integer "hourly", default: 0
    	t.string "role", default: 'user'
    	t.boolean "full_time", default: false
    	t.timestamps
    end
  end
end
