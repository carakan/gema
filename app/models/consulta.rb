# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Consulta < ActiveRecord::Base
  before_create :adicionar_usuario
  before_create :disminuir_cruces_pendientes, :if => :importacion_id? #lambda { |c| !!c.importacion.nil? }
  before_destroy :aumentar_cruces_pendientes, :if => :importacion_id?
  before_save :serializar_marca_ids
  before_save :serializar_parametros

  belongs_to :marca
  belongs_to :usuario
  belongs_to :importacion

  has_many :consulta_detalles, :dependent => :destroy
  accepts_nested_attributes_for :consulta_detalles

  validates_presence_of :comentario

  serialize :parametros
  serialize :marca_ids_serial

  PARAMS = [:clases, :tipo_busqueda, :fecha_ini, :fecha_fin]

  # Convierte los parametros que se utilizaron en la busqueda
  # como las clases, rangos de fechas y otros a un hash
  def self.convertir_parametros_a_hash(params)
    hash = { :clases => params[:clases].split(",").map(&:to_i) }
    [:tipo_busqueda, :fecha_ini, :fecha_fin].each do |v|
      hash[v] = params[v]
    end

    hash
  end

  # Realiza la busqueda de todos las marcas que existe en un cruce
  #   @param importacion_id Integer
  #   @param representante_id Integer
  #   @param tipo Symbol [:agentes, :titulares]
  def self.marcas_representante_cruce(importacion_id, representante_id, tipo)
    singular_id =  "#{tipo.to_s.singularize}_id"

    m_ids = Consulta.find_by_sql(["SELECT marca_id, #{singular_id} FROM marcas_#{tipo} 
                                     WHERE #{singular_id} = ?", representante_id]
    ).map(&:marca_id).flatten.uniq

    ConsultaDetalle.all( 
      :conditions => ["consultas.importacion_id = ? AND consulta_detalles.marca_id IN (?)", importacion_id, m_ids],
      :include => [ :consulta, :marca ]
    ).uniq
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

  # Retorna los representantes de las marcas que internvinieron en la
  # consulta
  def self.representantes(importacion_id, tipo)
    tipo = ['agentes', 'titulares'].include?(tipo) ? tipo.to_sym : :agentes
    
    marca_ids = Consulta.all(:select => "id, marca_ids_serial",
      :conditions => { :importacion_id => importacion_id}
    ).map(&:marca_ids_serial).flatten.compact.uniq

    Representante.marcas_representantes(marca_ids, tipo)
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

  # Descarta una consulta para un cruce, alamcenando la consulta pero sin datos de cruce
  def self.descartar(params)
    Consulta.create!(:marca_id => params[:marca_id], :descartada => true, :importacion_id => params[:importacion_id], :comentario => 'Descartada')
  end

  # Busca todos los titulares relacionados a una importacion
  #   @params Integer imp_id => importacion_id
  #   @param Symbol tipo => [ :agentes, :titulares ]
  #   @return Array
  def self.buscar_representantes(imp_id, tipo)
    marcas = Consulta.all(:select => 'consulta_detalles.marca_id', :conditions => { :importacion_id => imp_id }, 
      :include => :consulta_detalles ).map { |c| c.consulta_detalles.map(&:marca_id) }.flatten.uniq
    Marca.find(marcas, :include => tipo, :order => "representantes.nombre ASC").map { |m| m.send(tipo) }.flatten.uniq
  end

  private
  def adicionar_usuario
    self.usuario_id = UsuarioSession.current_user[:id]
  end


  def aumentar_cruces_pendientes
    modificar_cruces_pendientes(1)
  end

  def disminuir_cruces_pendientes
    modificar_cruces_pendientes(-1)
  end

  # Modifica los cruces pendientes en la importacion
  def modificar_cruces_pendientes(cant)
    unless self.importacion.nil?
      pend = self.importacion.cruces_pendientes
      self.importacion.update_attributes(:cruces_pendientes => (pend + cant) )
    end
  end
  
  def serializar_marca_ids
    self.marca_ids_serial = self.consulta_detalles.map(&:marca_id)
  end

  def serializar_parametros
    self.parametros = self.parametros
  end

end
