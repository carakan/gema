class RemoveColumnTipoTareaToInstruccionDetalles < ActiveRecord::Migration
  def self.up
    remove_column :instruccion_detalleses, :tipo_tarea
  end

  def self.down
    add_column :instruccion_detalleses, :tipo_tarea, :string
  end
end
