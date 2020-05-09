class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :time
      t.integer :course_id
      t.text :message
      t.string :info
      t.string :status, default: 'new'
      t.string :source

      t.timestamps
    end
  end
end
