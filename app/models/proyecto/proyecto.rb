class Proyecto::Proyecto < ActiveRecord::Base
  #attr_protected :representante_id, :area_id, :titulo, :referencia_cliente, :prioridad, :contacto_id
  set_table_name "proyectos"
  belongs_to :area
  belongs_to :representante
  has_and_belongs_to_many :contactos, :join_table => :proyectos_contactos
  has_many :correspondencias
  has_many :instruccions, :include => :instruccion_detalles
  has_many :proyecto_items
  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
  
  accepts_nested_attributes_for :adjuntos
  accepts_nested_attributes_for :correspondencias, :reject_if => proc {|attributes| attributes[:contenido].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :proyecto_items
  accepts_nested_attributes_for :instruccions
 
end

