class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string "picture"
    end
  end
end
