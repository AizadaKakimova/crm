class CreateCosts < ActiveRecord::Migration[5.1]
  def change
    create_table :costs do |t|
    	t.string "cost_name"
    	t.integer "user_id"
    	t.boolean "fix", default: false
    	t.integer "amount"
      	t.timestamps
    end
  end
end
