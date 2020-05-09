class AddCityToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :city_id, :integer
  end
end
