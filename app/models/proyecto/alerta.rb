class Proyecto::Alerta < Proyecto::InstruccionDetalle
  default_scope :conditions => {:tipo => 0}
end

