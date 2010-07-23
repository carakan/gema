class AddMarcasErroresValidaciones < ActiveRecord::Migration
  def self.up
    add_column :marcas, :errores, :string, :limit => 500
    add_column :marcas, :errores_manual, :string, :limit => 500
  end

  def self.down
    remove_column :marcas, :errores
    remove_column :marcas, :errores_manual
  end
end
