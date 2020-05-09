class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :slug
      t.boolean :enabled
      
      t.timestamps
    end
  end
end
