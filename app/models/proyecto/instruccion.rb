class Proyecto::Instruccion < ActiveRecord::Base
  attr_accessible :codigo, :proyecto_id, :gerencia_id, :referencia_email
  set_table_name "instruccions"
  belongs_to :proyecto
  has_many :instruccion_detalles

  def to_s
    id
  end 
end
