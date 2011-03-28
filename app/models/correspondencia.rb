class Correspondencia < ActiveRecord::Base
  attr_accessible :proyecto_id, :tipo, :contenido
  belongs_to :proyecto
end
