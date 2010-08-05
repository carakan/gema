class ConsultaDetalle < ActiveRecord::Base
  belongs_to :consulta
  belongs_to :marca
end
