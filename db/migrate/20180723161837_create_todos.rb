class CreateTodos < ActiveRecord::Migration[5.1]
  def change
    create_table :todos do |t|
      t.string :title
      t.references :user, foreign_key:

      t.timestamps
    end
  end
end
