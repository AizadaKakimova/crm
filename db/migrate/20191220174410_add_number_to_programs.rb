class AddNumberToPrograms < ActiveRecord::Migration[5.1]
  def change
    add_column :programs, :number, :integer
  end
end
