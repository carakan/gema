class ConsultaDetalle < ActiveRecord::Base
  belongs_to :consulta
  belongs_to :marca

  validates_presence_of :comentario
end
