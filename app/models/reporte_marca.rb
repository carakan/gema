class ReporteMarca < ActiveRecord::Base
  belongs_to :representante
  belongs_to :importacion
  has_many :reporte_marca_detalles, :dependent => :destroy
  
  accepts_nested_attributes_for :reporte_marca_detalles

  validates_presence_of :carta

  def self.buscar_representantes(imp_id)
    marcas = Consulta.all("marca_ids_serial", :conditions => { :importacion_id => imp_id } ).map(:marca_ids_serial)
  end

  # Crea el nombre de archivo para el pdf
  def crear_nombre_archivo
    if self.importacion_id.nil?
    else
      nombre = "Gaceta_" << self.importacion.publicacion
      nombre << "_" << (I18n.l self.importacion.publicacion_fecha, :format => "%d-%b-%Y")
      nombre << "_" << self.representante_type << "_" << self.representante.nombre
    end

    nombre
  end

end
