class Proyecto::Proyecto < ActiveRecord::Base
  attr_accessible :cliente_id, :area_id, :titulo, :referencia_cliente, :prioridad
  set_table_name "proyectos"
  belongs_to :area
  has_many :correspondencias
  has_many :instruccions
  has_many :proyecto_items
end
