class CreateProyectos < ActiveRecord::Migration
  def self.up
    create_table :proyectos do |t|
      t.integer :cliente_id
      t.integer :area_id
      t.string :titulo
      t.string :referencia_cliente
      t.string :prioridad
      t.timestamps
    end

    create_table :proyecto_contactos do |t|
      t.integer :proyecto_id, :cliente_id, :contacto_id
      t.timestamps
    end

    change_table :usuario do |t|
      t.integer :area_id
    end

    create_table :item_cobro_marcas do |t|
      t.integer :item_cobro_id, :marca_id
      t.timestamps
    end
  end

  def self.down
    drop_table :proyectos
  end
end
