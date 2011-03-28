class AddProyectoItemTipo < ActiveRecord::Migration
  def self.up
    add_column :proyecto_items, :tipo, :boolean
  end

   def self.down
    remove_column :proyecto_items, :tipo
  end
end