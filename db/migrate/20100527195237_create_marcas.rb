class CreateMarcas < ActiveRecord::Migration
  def self.up
    create_table :marcas do |t|
      t.integer :parent_id, :default => 0
#      t.integer :marca_id
      t.integer :usuario_id
      t.integer :titular_id
      t.integer :agente_id
      t.integer :tipo_signo_id
      t.integer :tipo_marca_id
      t.integer :clase_id
      t.integer :pais_id
      t.string :numero_solicitud, :limit => 40
      t.string :nombre
      t.string :numero_registro, :default => ''
      t.date   :fecha_registro
      t.string :numero_renovacion, :default => ''
      t.string :productos, :default => ''
      t.string :estado, :default => ''
      t.date :estado_fecha
      t.string :estado_serial
      t.string :numero_publicacion, :default => ''
      t.string :numero_gaceta, :default => ''
      t.string  :lema, :default => ''
      t.string  :imagen, :default => ''
      t.date  :fecha_publicacion
      t.string  :type, :default => ''
      t.integer :fila # Fila en la cual se produjo el error al importar
      t.datetime :fecha_importacion
      t.boolean :activo
      t.boolean :valido # Para indicar si la importación fue válida
      t.string :cambios, :default => [] # Indica que campos han sido modificados
      t.boolean :importado, :default => false
      t.string :apoderado
      t.string :representante_empresarial

      t.timestamps
    end

    add_index :marcas, :agente_id
    add_index :marcas, :titular_id
    add_index :marcas, :tipo_signo_id
    add_index :marcas, :tipo_marca_id
    add_index :marcas, :clase_id
    add_index :marcas, :usuario_id
    add_index :marcas, :parent_id
    add_index :marcas, :pais_id
#    add_index :marcas, :marca_id

    add_index :marcas, :fecha_importacion
    add_index :marcas, :type
    add_index :marcas, :importado

  end

  def self.down
    drop_table :marcas
  end
end
