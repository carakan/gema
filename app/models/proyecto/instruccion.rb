class Proyecto::Instruccion < ActiveRecord::Base
  #attr_accessible :proyecto_id, :area_id, :referencia_email
  set_table_name "instruccions"
  belongs_to :proyecto
  has_many :instruccion_detalles
  accepts_nested_attributes_for :instruccion_detalles

  belongs_to :email, :foreign_key => :referencia_email, :class_name => "Proyecto::Correspondencia"
  
  has_many :tareas_revision, :conditions => {:estado_tarea => 'revision'}, :order => 'fecha_limite ASC', :class_name => 'Proyecto::InstruccionDetalle'
  has_many :tareas_pendientes, :conditions => {:estado_tarea => 'pendiente'}, :order => 'fecha_limite ASC', :class_name => 'Proyecto::InstruccionDetalle'

  def to_s
    id
    proyecto_id
  end 

end
