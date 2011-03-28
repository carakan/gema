class Proyecto::Instruccion < ActiveRecord::Base
  attr_accessible :codigo, :proyecto_id, :gerencia_id, :referencia_email
  set_table_name "instruccions"
end
