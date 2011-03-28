class Proyecto::InstruccionDetalle < ActiveRecord::Base
  attr_accessible :codigo, :instruccion_id, :usuario_id, :tarea, :fecha_limite, :estado
  set_table_name "instruccion_detalles"
  belongs_to :instruccion
  has_and_belongs_to_many :proyecto_items
end
