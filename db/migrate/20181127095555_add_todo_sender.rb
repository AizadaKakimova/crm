class AddTodoSender < ActiveRecord::Migration[5.1]
  def change
    add_column :todos, :todo_sender, :integer
  end
end
