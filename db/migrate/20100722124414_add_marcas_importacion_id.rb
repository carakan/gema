class AddMarcasImportacionId < ActiveRecord::Migration
  def self.up
    add_column :marcas, :importacion_id, :integer
    add_index :marcas, :importacion_id 
  end

  def self.down
    remove_column :marcas, :importacion_id
  end
end
