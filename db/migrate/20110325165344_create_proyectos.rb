class CreateProyectos < ActiveRecord::Migration
  def self.up
    create_table :proyectos do |t|
      t.integer :contacto_id
      t.integer :representante_id
      t.integer :area_id
      t.string :titulo
      t.string :referencia_cliente
      t.string :prioridad
      t.timestamps
    end

    create_table :proyecto_contactos do |t|
      t.integer :proyecto_id, :representante_id, :contacto_id
      t.timestamps
    end

    change_table :usuarios do |t|
      t.integer :area_id
    end

    create_table :item_cobros_marcas, :id => false do |t|
      t.integer :proyecto_item_id, :marca_id
    end

    create_table :instruccion_detalles_item_cobros,:id => false do |t|
      t.integer :instruccion_detalle_id, :proyecto_item_id
    end
  end

  def self.down
    drop_table :proyectos
    drop_table :proyecto_contactos
    change_table :usuarios do |t|
      t.remove :area_id
    end
    drop_table :item_cobro_marcas
    drop_table :instruccion_item_cobro
  end
end

