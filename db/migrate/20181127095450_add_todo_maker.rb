class AddTodoMaker < ActiveRecord::Migration[5.1]
  def change
    add_column :todos, :todo_maker, :integer
  end
end
