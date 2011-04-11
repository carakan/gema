class Proyecto::Correspondencia < ActiveRecord::Base
  belongs_to :proyecto
  #validates :contenido, :presence => true
end
