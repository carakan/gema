class AddColumnTipoTareaToInstruccionDetalles < ActiveRecord::Migration
  def self.up
    add_column :instruccion_detalles, :tipo_tarea, :string
  end

  def self.down
    remove_column :instruccion_detalles, :tipo_tarea
  end
end
