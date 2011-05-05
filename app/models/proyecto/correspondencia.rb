class Proyecto::Correspondencia < ActiveRecord::Base
  belongs_to :proyecto
  #validates :contenido, :presence => true
  set_table_name "correspondencias"
  
  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
  accepts_nested_attributes_for :adjuntos, :allow_destroy => true
  
  def siguiente_id
    codigo = Proyecto::Correspondencia.select("max(contador) as conteo").where(["proyecto_id = ?", proyecto_id]).first
    return(codigo.conteo + 1) 
  rescue
    return 1
  end
  
  def to_s
    "P#{self.proyecto.id} C#{self.contador}"
  end
end
