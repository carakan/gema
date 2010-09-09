# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ReporteMarca < ActiveRecord::Base
  before_create :destruir_anteriores, :if => lambda { |r| r.importacion_id? }

  belongs_to :representante
  belongs_to :importacion
  has_many :reporte_marca_detalles, :dependent => :destroy

  IDIOMAS = [['Español', 'es'], ['Ingles', 'en']]
  
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

  # Construye un reporte a partir de busquedas realizadas
  #   @param Hash
  #   @return ReporteMarca
  def self.nuevo_busqueda(params)
    Consulta.all(:select => "consulta_detalles.marca_id", :unclude => :consulta_detalles)
  end

  # Carta base 
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
