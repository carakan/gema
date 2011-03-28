class Proyecto::Proyecto < ActiveRecord::Base
  attr_accessible :cliente_id, :area_id, :titulo, :referencia_cliente, :prioridad
  set_table_name "proyectos"
end
