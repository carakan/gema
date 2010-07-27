class CreateImportaciones < ActiveRecord::Migration
  def self.up
    create_table :importaciones do |t|
      t.string :gaceta
      t.boolean :completa
      t.string :publicacion
      t.string :archivo_file_name
      t.integer :archivo_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :importaciones
  end
end
