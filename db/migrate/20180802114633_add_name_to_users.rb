class AddNameToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :name, :string
  	add_column :users, :school, :string
  	add_column :users, :birthdate, :datetime
  end
end
