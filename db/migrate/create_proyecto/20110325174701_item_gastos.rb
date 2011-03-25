class CreateProyecto::ItemGastos < ActiveRecord::Migration
  def self.up
    create_table :proyecto/item_gastos do |t|
      t.float :monto
      t.datetime :fecha_solicitud
      t.timestamps
    end
  end

  def self.down
    drop_table :proyecto/item_gastos
  end
end
