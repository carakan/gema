class RemoveColumnMostrarToArea < ActiveRecord::Migration
  def self.up
    remove_column :areas, :mostrar
  end

  def self.down
    add_column :areas, :mostrar, :boolean
  end
end
