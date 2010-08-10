class Consulta < ActiveRecord::Base
  before_create :adicionar_usuario
  before_create :disminuir_cruces_pendientes
  before_create :crear_reporte, :if => lambda { |c| !!c.importacion.nil? }
  before_destroy :aumentar_cruces_pendientes#, :if => lambda { |c| !!c.importacion.nil? }

  belongs_to :marca
  belongs_to :usuario
  belongs_to :importacion

  has_many :consulta_detalles, :dependent => :destroy
  accepts_nested_attributes_for :consulta_detalles

  validates_presence_of :comentario

  serialize :parametros

  # Convierte los parametros que se utilizaron en la busqueda
  # como las clases, rangos de fechas y otros a un hash
  def self.convertir_parametros_a_hash(params)
    hash = { :clases => params[:clases].split(",").map(&:to_i) }
  end


  # Crea una consulta a partir de los detalles
  def self.nueva(params)
    klass = new(
      :parametros => convertir_parametros_a_hash(params).to_yaml,
      :busqueda => params[:busqueda]
    )

    klass.set_importacion_id(params)
    klass.set_marca_id(params)

    klass.instanciar_marcas_detalles(params)

    klass
  end

  def set_importacion_id(params)
    self.importacion_id = params[:importacion_id] unless params[:importacion_id].nil?
  end

  def set_marca_id(params)
    self.marca_id = params[:marca_id] unless params[:marca_id].nil?
  end

  # Ordena para poder presentar en el orden que aparecieronen 
  # la busqueda y poder presentar
  def instanciar_marcas_detalles(params)
    @marca_ids ||= []
    params[:marcas].keys.map(&:to_i).sort.each do |k|
      # Array de marcas que mejora la velocidad para el listado
      k = k.to_s
      self.consulta_detalles.build(
        :marca_id => params[:marcas][k],
        :tipo => params[:tipos][k] 
      )
    end
  end


private
  def adicionar_usuario
    self.usuario_id = UsuarioSession.current_user[:id]
  end

  # Almacena el reporte creado por la consulta
  def crear_reporte
    self.reporte = ''
  end

  def aumentar_cruces_pendientes
    modificar_cruces_pendientes(1)
  end

  def disminuir_cruces_pendientes
    modificar_cruces_pendientes(-1)
  end

  # Modifica los cruces pendientes en la importacion
  def modificar_cruces_pendientes(cant)
    pend = self.importacion.cruces_pendientes
    self.importacion.update_attributes(:cruces_pendientes => (pend + cant) )
  end
end
