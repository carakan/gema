class ReporteMarcaDetalle < ActiveRecord::Base
  belongs_to :reporte_marca

  validates_presence_of :comentario
end
