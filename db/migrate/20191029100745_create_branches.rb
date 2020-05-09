class CreateBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :branches do |t|
      t.references :city, index: true
      t.string :name
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
