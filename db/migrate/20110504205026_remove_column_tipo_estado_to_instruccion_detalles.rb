class RemoveColumnTipoEstadoToInstruccionDetalles < ActiveRecord::Migration
  def self.up
    remove_column :instruccion_detalles, :tipo_estado
  end

  def self.down
    add_column :instruccion_detalles, :tipo_estado, :string
  end
end
