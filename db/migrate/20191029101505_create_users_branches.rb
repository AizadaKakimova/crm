class CreateUsersBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :users_branches do |t|
      t.references :user, foreign_key: true
      t.references :branch, foreign_key: true
    end
  end
end
