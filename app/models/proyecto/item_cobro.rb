class Proyecto::ItemCobro < Proyecto::ProyectoItem 
 has_and_belongs_to_many :instruccion_detalles
 has_and_belongs_to_many :marcas 
end