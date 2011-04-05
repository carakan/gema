class Proyecto::ItemGasto < Proyecto::ProyectoItem 
  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
end
