class AddMarcasPropia < ActiveRecord::Migration
  def self.up
    add_column :marcas, :propia, :boolean, :default => false
    add_index :marcas, :propia
  end

  def self.down
    remove_column :marcas, :propia
  end
end
