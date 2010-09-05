class ReporteMarcaDetalle < ActiveRecord::Base
  before_save :ignorar_vacios

  belongs_to :reporte_marca

  validates_length_of :comentario, :minimum => 30, :unless => lambda { |r| r.comentario.blank? }

private
  # Ignora todas las marcas que no se escribio algún comentario
  def ignorar_vacios
    self.ignorar = self.comentario.blank?
  end
end
