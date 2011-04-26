class AddEstadoTareaInstrucciondetalles < ActiveRecord::Migration
  def self.up
    add_column :instruccion_detalles, :estado_tarea, :string
  end

   def self.down
    remove_column :instruccion_detalles, :estado_tarea
  end
end
