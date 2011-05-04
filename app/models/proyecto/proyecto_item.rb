class Proyecto::ProyectoItem < ActiveRecord::Base
  # TODO research about attr_accesible
  #attr_accessible :codigo, :proyecto_id, :descripcion, :estado, :referencia_cliente, :referencia_cliente_cobranza, :fecha_limite, :honorarios, :gastos_adminitrativos, :monto, :fecha_solicitud
  belongs_to :proyecto
  belongs_to :item

  set_table_name 'proyecto_items'

  def obtener_codigo
    codigo = Proyecto::ProyectoItem.select("max(contador) as conteo").where("tipo = 1", ["proyecto_id = ?", proyecto_id]).first
    return(codigo.conteo + 1) 
  end
  
  def to_s
    "P#{self.proyecto.id} S#{self.contador}"
  end
end