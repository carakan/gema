class Proyecto < ActiveRecord::Base
  attr_accessible :cliente_id, :area_id, :titulo, :referencia_cliente, :prioridad
end
