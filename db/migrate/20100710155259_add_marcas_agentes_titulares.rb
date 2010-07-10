class AddMarcasAgentesTitulares < ActiveRecord::Migration
  def self.up
    add_column :marcas, :agente_ids_serial, :string
    add_column :marcas, :titular_ids_serial, :string
  end

  def self.down
    remove_column :marcas, :agente_ids_serial
    remove_column :marcas, :titular_ids_serial
  end
end
