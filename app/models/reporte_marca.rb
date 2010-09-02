class ReporteMarca < ActiveRecord::Base
  belongs_to :representante
  belongs_to :importacion
  has_many :reporte_marca_detalles, :dependent => :destroy
  accepts_nested_attributes_for :reporte_marca_detalles
end
