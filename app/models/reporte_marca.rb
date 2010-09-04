class ReporteMarca < ActiveRecord::Base
  belongs_to :representante
  belongs_to :importacion
  has_many :reporte_marca_detalles, :dependent => :destroy
  accepts_nested_attributes_for :reporte_marca_detalles

  def self.buscar_representantes(imp_id)
    marcas = Consulta.all("marca_ids_serial", :conditions => { :importacion_id => imp_id } ).map(:marca_ids_serial)
  end
end
