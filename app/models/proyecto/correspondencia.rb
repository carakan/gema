class Proyecto::Correspondencia < ActiveRecord::Base
  belongs_to :proyecto
  #validates :contenido, :presence => true
  set_table_name "correspondencias"
  
  def to_s
    "P#{self.proyecto.id} C#{self.contador}"
  end
end
