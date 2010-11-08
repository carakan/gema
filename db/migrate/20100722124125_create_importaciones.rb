class CreateImportaciones < ActiveRecord::Migration
  def self.up
    create_table :importaciones do |t|
      t.boolean :completa
      t.string :publicacion, :limit => 30
      t.date :publicacion_fecha
      t.string :tipo
      t.string :archivo_file_name
      t.integer :archivo_file_size
      t.integer :cruces_pendientes, :default => -1
      t.integer :usuario_id

      t.timestamps
    end
  end

  def self.down
    drop_table :importaciones
  end
end
