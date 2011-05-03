class Proyecto::TipoInstruccion < ActiveRecord::Base
  attr_accessible :nombre
  has_many :instruccion_detalles
end

