class ChangeRequestsDefault < ActiveRecord::Migration[5.1]
  def change
  	change_column :requests, :status, :string, default: "Новая"
  end
end
