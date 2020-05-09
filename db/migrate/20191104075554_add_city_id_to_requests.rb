class AddCityIdToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :city_id, :integer
  end
end
