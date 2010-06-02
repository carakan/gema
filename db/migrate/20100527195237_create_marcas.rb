class CreateMarcas < ActiveRecord::Migration
  def self.up
    create_table :marcas do |t|
      t.integer :usuario_id
      t.integer :titular_id
      t.integer :agente_id
      t.integer :tipo_marca_id
      t.integer :clase_id
      t.integer :marca_id
      t.string :sm, :limit => 40
      t.string :nombre
      t.string :numero_registro
      t.string :numero_renovacion
      t.string :productos
      t.string :estado
      t.date :estado_fecha
      t.string :estado_serial
      t.string :publicacion
      t.string :gaceta
      t.integer :fila # Fila en la cual se produjo el error al importar
      t.integer :fecha_importacion
      t.boolean :activo
      t.boolean :valido # Para indicar si la importación fue válida

      t.timestamps
    end

    add_index :marcas, :agente_id
    add_index :marcas, :titular_id
    add_index :marcas, :tipo_marca_id
    add_index :marcas, :clase_id
    add_index :marcas, :usuario_id
    add_index :marcas, :marca_id

  end

  def self.down
    drop_table :marcas
  end
end
