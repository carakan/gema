class Proyecto::InstruccionDetalle < ActiveRecord::Base
  attr_accessible :instruccion_id, :usuario_id, :tarea, :fecha_limite, :estado
  set_table_name "instruccion_detalles"
  belongs_to :instruccion
  has_and_belongs_to_many :item_cobros, :association_foreign_key => :proyecto_item_id
  belongs_to :usuario
end
