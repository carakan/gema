class RenameConsultaDetallesTipo < ActiveRecord::Migration
  def self.up
    rename_column :consulta_detalles, :tipo, :tipo_de_busqueda
  end

  def self.down
    rename_column :consulta_detalles, :tipo_de_busqueda, :tipo
  end
end
