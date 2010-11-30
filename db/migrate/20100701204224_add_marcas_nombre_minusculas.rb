# encoding: utf-8
class AddMarcasNombreMinusculas < ActiveRecord::Migration
  def self.up
    add_column :marcas, :nombre_minusculas, :string
    add_index :marcas, :nombre_minusculas
  end

  def self.down
    remove_column :marcas, :nombre_minusculas
  end
end
