class Proyecto::InstruccionDetalle < ActiveRecord::Base
  attr_accessible :codigo, :instruccion_id, :usuario_id, :tarea, :fecha_limite, :estado
end
