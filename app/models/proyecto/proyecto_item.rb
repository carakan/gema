class Proyecto::ProyectoItem < ActiveRecord::Base
  # TODO research about attr_accesible
  #attr_accessible :codigo, :proyecto_id, :descripcion, :estado, :referencia_cliente, :referencia_cliente_cobranza, :fecha_limite, :honorarios, :gastos_adminitrativos, :monto, :fecha_solicitud
  belongs_to :proyecto
  has_many :items_relaciones
  has_many :items, :trougth => :items_relaciones, :source => :item

  set_table_name 'proyecto_items'

  def siguiente_id
    codigo = Proyecto::ProyectoItem.select("max(contador) as conteo").where(["proyecto_id = ?", proyecto_id]).first
    return(codigo.conteo + 1) 
  rescue
    return 1
  end
  
  def to_s
    "P#{self.proyecto.id} ITEM#{self.contador}"
  end
end
