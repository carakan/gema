class Proyecto::ItemGasto < Proyecto::ProyectoItem 
  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
  accepts_nested_attributes_for :adjuntos
  
  default_scope :conditions => {:tipo => 0}
  
  def siguiente_id
    codigo = Proyecto::ProyectoItem.select("max(contador) as conteo").where(["proyecto_id = ? && tipo = ?", proyecto_id, 0]).first
    return(codigo.conteo + 1) 
  rescue
    return 1
  end

  
  def to_s
    "P#{self.proyecto.id} G#{self.contador}"
  end
end
