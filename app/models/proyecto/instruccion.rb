class Proyecto::Instruccion < ActiveRecord::Base
  #attr_accessible :proyecto_id, :area_id, :referencia_email
  set_table_name "instruccions"
  belongs_to :proyecto
  has_many :instruccion_detalles
  accepts_nested_attributes_for :instruccion_detalles
  
  has_many :revision_tareas, :conditions => {:estado_tarea => 'revision'}, :order => 'fecha_limite ASC', :class_name => 'Proyecto::InstruccionDetalle'

  def to_s
    id
    proyecto_id
  end 
end
