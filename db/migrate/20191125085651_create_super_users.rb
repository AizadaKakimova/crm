class CreateSuperUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :super_users do |t|
      t.integer "user_id"
      t.timestamps
    end
  end
end
