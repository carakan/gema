class Consulta < ActiveRecord::Base
  before_create :adicionar_usuario
  before_create :crear_reporte

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
      :parametros => convertir_parametros_a_hash(params),
      :busqueda => params[:busqueda]
    )

    klass.importacion_id = params[:importacion_id] unless params[:importacion_id].nil?
    klass.instanciar_marcas_detalles(params)

    klass
  end

  # Ordena para poder presentar en el orden que aparecieronen 
  # la busqueda y poder presentar
  def instanciar_marcas_detalles(params)
    params[:marcas].keys.map(&:to_i).sort.each do |k|
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

end
