class ConsultaDetalle < ActiveRecord::Base
  belongs_to :consulta
  belongs_to :marca

  validates_presence_of :marca_id
  #validates_presence_of :comentario
   
  # Usado para el formulario maestro detalle
  def marca_detalle
    @marcas ||= Marca.find(self.consulta.marca_ids, :select => 'id, nombre')
    @marcas.find { |v| v.id == self.marca_id }
  end

end
