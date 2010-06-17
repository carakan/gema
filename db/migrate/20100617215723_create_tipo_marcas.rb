class CreateTipoMarcas < ActiveRecord::Migration
  def self.up
    create_table :tipo_marcas do |t|
      t.string :nombre, :limit => 100
      t.string :descripcion, :limit => 255

      t.timestamps
    end
  end

  def self.down
    drop_table :tipo_marcas
  end
end
