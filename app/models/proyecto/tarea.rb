class Proyecto::Tarea < Proyecto::InstruccionDetalle
  default_scope :conditions => {:tipo => 1}
end
