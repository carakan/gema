class CreateProyectoItems < ActiveRecord::Migration
  def self.up
    create_table :proyecto_items do |t|
      t.integer :proyecto_id
      t.string :descripcion
      t.string :estado
      t.string :referencia_cliente
      t.string :referencia_cliente_cobranza
      t.date :fecha_limite
      t.float :honorarios
      t.float :gastos_adminitrativos
      t.float :monto
      t.date :fecha_solicitud
      t.timestamps
    end
  end

  def self.down
    drop_table :proyecto_items
  end
end
