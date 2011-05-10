class Proyecto::ItemCobro < Proyecto::ProyectoItem 
  has_and_belongs_to_many :instruccion_detalles, :foreign_key => :proyecto_item_id
  has_and_belongs_to_many :marcas, :foreign_key => :proyecto_item_id
 
  default_scope :conditions => {:tipo => 1}
  
  def siguiente_id
    codigo = Proyecto::ProyectoItem.select("max(contador) as conteo").where(["proyecto_id = ? && tipo = ?", proyecto_id, 1]).first
    return(codigo.conteo + 1) 
  rescue
    return 1
  end
  
  def to_s
    "P#{"%04d" % self.proyecto.id} S#{"%02d" % self.contador}"
  end
end
