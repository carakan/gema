class Proyecto::Proyecto < ActiveRecord::Base
  attr_accessible :representante_id, :area_id, :titulo, :referencia_cliente, :prioridad, :contacto_id
  set_table_name "proyectos"
  belongs_to :area
  belongs_to :representante
  #belongs_to :contacto
  has_many :correspondencias
  has_many :instruccions
  has_many :proyecto_items

def to_s
 titulo
end
end

