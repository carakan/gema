class AddColumnNroTramiteToProyectoItems < ActiveRecord::Migration
  def self.up
    add_column :proyecto_items, :nro_tramite, :string
  end

  def self.down
    remove_column :proyecto_items, :nro_tramite
  end
end
