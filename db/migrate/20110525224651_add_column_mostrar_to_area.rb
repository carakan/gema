class AddColumnMostrarToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :mostrar, :boolean
  end

  def self.down
    remove_column :areas, :mostrar
  end
end
