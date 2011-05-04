class Proyecto::TipoInstruccion < ActiveRecord::Base
  attr_accessible :nombre, :sigla
  has_many :instruccion_detalles
end

