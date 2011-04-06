class Proyecto::ItemGasto < Proyecto::ProyectoItem 
  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
  accepts_nested_attributes_for :adjuntos
end
