class ReporteMarcaDetalle < ActiveRecord::Base
  belongs_to :reporte_marca

  validates_length_of :comentario, :minimum => 30, :unless => lambda { |r| r.comentario.blank? }

end
