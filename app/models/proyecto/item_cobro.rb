class Proyecto::ItemCobro < Proyecto::ProyectoItem 
 has_and_belongs_to_many :instruccion_detalles, :foreign_key => :proyecto_item_id
 has_and_belongs_to_many :marcas, :foreign_key => :proyecto_item_id
end
