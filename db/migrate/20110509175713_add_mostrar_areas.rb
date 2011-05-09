class AddMostrarAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :mostrar, :boolean, :default => 0
  end

  def self.down
    add_column :areas, :mostrar
  end
end
