class AddMarcasFechaSolicitud < ActiveRecord::Migration
  def self.up
    add_column :marcas, :fecha_solicitud, :date
  end

  def self.down
    remove_column :marcas, :fecha_solicitud
  end
end
