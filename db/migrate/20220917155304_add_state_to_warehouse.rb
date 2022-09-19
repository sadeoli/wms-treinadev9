class AddStateToWarehouse < ActiveRecord::Migration[7.0]
  def change
    add_column :warehouses, :state, :string
  end
end
