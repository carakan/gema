class CreateProyecto::ItemCobros < ActiveRecord::Migration
  def self.up
    create_table :proyecto/item_cobros do |t|
      t.string :referencia_cliente
      t.string :referencia_cliente_cobranza
      t.date :fecha_limite
      t.float :honorarios
      t.float :gastos_administrativos
      t.timestamps
    end
  end

  def self.down
    drop_table :proyecto/item_cobros
  end
end
