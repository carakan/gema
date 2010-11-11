# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ReporteMarca < ActiveRecord::Base
  before_create :destruir_anteriores, :if => lambda { |r| r.importacion_id? }

  belongs_to :representante
  belongs_to :importacion
  belongs_to :consulta
  has_many :reporte_marca_detalles, :dependent => :destroy

  IDIOMAS = [['Español', 'es'], ['Ingles', 'en']]
  
  accepts_nested_attributes_for :reporte_marca_detalles

  validates_presence_of :carta, :representante_id
  validates_associated :representante

  def self.buscar_representantes(imp_id)
    marcas = Consulta.all("marca_ids_serial", :conditions => { :importacion_id => imp_id } ).map(:marca_ids_serial)
  end

  # Crea el nombre de archivo para el pdf
  def crear_nombre_archivo
    if self.importacion_id?
      nombre = "#{self.id}_Gaceta_" << self.importacion.publicacion
      nombre << "_" << (I18n.l self.importacion.publicacion_fecha, :format => "%d-%b-%Y")
      nombre << "_" << self.representante_type << "_" << self.representante.nombre
    else
      nombre = "#{self.id}_busquedas_#{self.representante.nombre}"
    end

    nombre
  end

  # Retorna el nombre del idioma en base a la abreviación que fue almacenada en la BD
  def idioma!
    IDIOMAS.find { |v| v.last == self.idioma }.first
  end

  # Elimina todas los reportes anteriores basado en los parametros
  def self.destroy_anteriotes(params)
    destroy_all(conditions_buscar(params))
  end

  # Realiza la busqueda por argumentos
  def self.buscar_en_cruce(params)
    first(:conditions => condiciones_buscar_cruce(params) )
  end

  # Crea las condiciones para la busqueda
  def self.condiciones_buscar_cruce(params)
    { 
      :importacion_id => params[:importacion_id], 
      :representante_id => params[:representante_id],
      :representante_type => params[:representante_type]
    }
  end

  # Prepara el formulario para un reporte a partir de busquedas realizadas
  #   @param Hash
  #   @return ReporteMarca
  def self.nuevo_busqueda(params)
    detalles = ConsultaDetalle.all(:select => "consulta_detalles.marca_id, consultas.busqueda", 
                                    :conditions => { :consulta_id => params[:consulta_id] },
                                    :include => :consulta)
    reporte_marca = new(:idioma => params[:idioma])
    carta = ""
    detalles.each { |cd| 
      reporte_marca.reporte_marca_detalles.build(:marca_id => cd.marca_id, :busqueda => cd.consulta.busqueda )
    }
    reporte_marca.consulta_id = params[:consulta_id]
    reporte_marca.carta = detalles.first.consulta.comentario if !detalles.empty? && detalles.first.consulta
    reporte_marca.busqueda = detalles.first.consulta.busqueda if !detalles.empty? && detalles.first.consulta
    reporte_marca
  end

  # Carta base 
  #   @param String ['es', 'en']
  #   @return String
  def crear_carta(idiom = 'es')
    if 'es' == idiom
      c = <<-CARTA
      Estimado cliente le enviamos las coincidencias de marcas #{ carta_extra_info(idiom) }
      CARTA
    else
      c = <<-CARTA
        Dear customer we have found some coincidences with your trademarks #{ carta_extra_info(idiom) }
      CARTA
    end
    c.strip
  end

  # Realiza la creación del reporte para un cruce o busqueda
#  def crear_reporte
#    if self.importacion_id?
#      @report = Reporte.find_by_clave("busqueda_report")
#      rep = CruceReport.new
#      rep.to_pdf(self)
#    else
#      @report = Reporte.find_by_clave("cruce_report")
#      rep = BusquedaReport.new
#      rep.to_pdf(self)
#    end
#  end

private
  # Extra de info para la carta
  def carta_extra_info(idiom)
    case 
    when( 'es' == idiom and !self.importacion_id? )
      "de las busquedas solicitadas"
    when( 'es' == idiom and self.importacion_id? )
      "en la gaceta #{self.importacion.publicacion} de fecha #{ I18n.l self.importacion.publicacion_fecha }"
    when 'en' == idiom
      if self.importacion_id?
        I18n.locale = :en
        text = "in gaceta #{self.importacion.publicacion} from date #{ I18n.l self.importacion.publicacion_fecha }"
        I18n.locale = :es
      else
        text = "in your requested trademarks search"
      end
      text
    end
  end

  # Callback que elimina todos los registros anteriores para cuando se crea
  # un reporte
  def destruir_anteriores
    self.class.destroy_all( self.class.condiciones_buscar_cruce(self.attributes.convert_keys_to_sym) )
  end

end
