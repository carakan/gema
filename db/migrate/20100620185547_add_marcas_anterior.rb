class AddMarcasAnterior < ActiveRecord::Migration
  def self.up
    add_column :marcas, :anterior, :boolean, :default => false
  end

  def self.down
    remove_column :marcas, :anterior
  end
end
