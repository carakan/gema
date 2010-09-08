# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Marca < ActiveRecord::Base

  #before_save :set_propia
  before_save :quitar_comillas
  before_save :set_minusculas
  before_save :adicionar_usuario
  before_save :set_agentes_titulares, :if => lambda { |m| m.parent_id == 0 }
  before_save :llenar_productos, :if => lambda { |m| m.productos.blank? }

  # Numero de palabras
  #before_save lambda { |m| m.numero_palabras = m.nombre_minusculas.strip.split(/\s/).size } 

  before_update :crear_historico, :if => :con_historico?
  before_update :set_cambios
  before_save :actualizar_validez

  belongs_to :clase
  belongs_to :tipo_signo
  belongs_to :tipo_marca
  belongs_to :usuario
  #belongs_to :pais
  belongs_to :importacion

  has_many :posts, :as => :postable, :order => 'created_at DESC'
  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
  accepts_nested_attributes_for :adjuntos
  has_many :consultas
  has_many :consulta_detalles

  POSTS_SIZE = 2

  #has_many :marcas_representantes#, :as => :representable

  #include HasManyRight
  #has_many_right :agentes, :representante, :marca_representante, :representable
  #has_many_right :titulares, :representante ,:marca_representante, :representable
  
  has_and_belongs_to_many :agentes, :class_name => 'Representante',
    :association_foreign_key => :agente_id,
    :join_table => 'marcas_agentes'
  has_and_belongs_to_many :titulares, :class_name => 'Representante',
    :association_foreign_key => :titular_id,
    :join_table => 'marcas_titulares'

  def after_initialize
    @con_historico = true
  end

  def con_historico?
    @con_historico
  end

  def con_historico=(val)
    @con_historico = val
  end

  # Las validaciones se guardan en los modulos 

  # Serializaciones, Denormalizacion de datos
  serialize :cambios
  serialize :agente_ids_serial
  serialize :titular_ids_serial
  serialize :errores
  # Errores especiales que deben ser eliminados manualmente debido a que el error
  # es validado por un criterio que no puede identificarse en el sistema
  serialize :errores_manual


  validates_presence_of :estado
  validate :validar_errores_manual

  default_scope :conditions => "marcas.parent_id = 0"

  #named_scope :importados, lambda{ |fecha| 
  #  { :conditions => { :fecha_importacion => fecha} } 
  #}

  named_scope :importado, lambda { |imp_id, nombre_marca| 
    { 
      :conditions => [ "marcas.importacion_id = ? AND marcas.nombre_minusculas LIKE ?", imp_id, "%#{nombre_marca.downcase}%" ], 
      :order => "marcas.valido, marcas.propia DESC", 
      :include => [:tipo_signo, :clase, :titulares] 
    } 
  }

  named_scope :importados_error, lambda { |fecha| 
    { :conditions => { :fecha_importacion => fecha, :valido => false} } 
  }

  named_scope :cruce, lambda { |importacion_id, nombre_marca| 
    { 
      :conditions =>  [
        "marcas.importacion_id = ? AND marcas.tipo_signo_id NOT IN (?) AND marcas.nombre_minusculas LIKE ?", 
        importacion_id, TipoSigno.descartadas_cruce, "%#{nombre_marca.downcase}%"
      ],
      :include => [:tipo_signo, :clase, { :consultas => :usuario }, :titulares ]
    }
  }

  # Configuracion de thinking-sphinx
  #define_index do
  #  indexes nombre_minusculas
  #  indexes nombre

  #  has clase_id, created_at, updated_at
  #end

  TIPOS = {
    'sm' => 'Solicitud de Marca',
    'lp' => 'Lista de publicación',
    'lr' => 'Lista de Registro',
    'sr' => 'Solicitud de Renovación',
    'rc' => 'Renovaciones Concedidas'
  }

  ESTADOS = TIPOS

  SIGNOS = {
    'sigden' => 'Marcas Denomainativas',
    'sigfig' => 'Marcas Figurativas',
    'sigmix' => 'Marcas Mixtas',
    'sigtri' => 'Marcas Tridimensionales',
    'signcd' => 'Nombre Comercial Denominativo',
    'signcm' => 'Nombre Comercial Mixto',
    'siglc' => 'Lema Comercial'
  }

  # Modulo base para la importacion desde excel
  include ModMarca::Excel

  # Extra para poder importar
  attr_accessor :tipo, :archivo, :fecha_gen

  def to_s
    nombre
  end

  def ver_estado
    TIPOS[estado]
  end

  def con_imagen?
    [2, 3, 4].include? self.tipo_signo_id
  end

  def ver_fila
    "El error fue encontrado en la fila #{fila} del archivo importado" if fila and valido == false
  end

  def propia!
    propia? ? "propia" : "foranea"
  end

  def valido!
    valido? ? "" : "error"
  end

  # Transforma los errores en un Hash que puede ser utilizado para JSON
  def hashify_errors
    self.errors.map(&:first).uniq.inject({}) { |h, v| 
      h[v] = (self.errors[v].is_a?(Array) ) ? self.errors[v].join(', ') : self.errors[v]
      h 
    }
  end

  # Metodo que permite realizar las importaciones
  #   @param Hash params Parametros que se recibe de el formulario
  def self.importar(params)
    set_include_estado(params[:tipo])
    importar_archivo(params)
  end

  # Realiza la inclusion de modulos de acuerdo al estado
  def self.set_include_estado(estado)
    case estado
      when 'sm'
        include ModMarca::Solicitud
      when 'lp'
        include ModMarca::ListaPublicacion
      when 'lr'
        include ModMarca::ListaRegistro
      when 'sr'
        include ModMarca::SolicitudRenovacion
      when 'rc'
        include ModMarca::RenovacionConcedida
    end
  end

  # Realiza la inclusion de modulos de acuerdo al tipo_signo
  def self.set_include_tipo_signo(signo)
    case signo
      when 1
        include ModMarca::Denominacion
      when 2
        include ModMarca::Etiqueta
      when 3
        include ModMarca::Figurativa
    end
  end


  def self.ver_estado(est)
    TIPOS[est]
  end

  # Presenta una lista que puede ser usada en
  # formularios de seleccion multiple
  def self.lista_estados
    orden = ['sm' ,'lp', 'lr', 'sr', 'rc']
    orden.inject([]) { |arr, val| arr << [TIPOS[val], val] }
  end

  def self.lista_tiposignos
    tipos = ['sigden', 'sigfig', 'sigmix','sigtri','signcd','signcm','siglc']
    tipos.inject([]) { |arr, val| arr << [SIGNOS[val], val] }
  end

  def self.buscar(*args)
    options = args.extract_options!
    params = options.delete(:params)
    
    unless params['propia'].nil?
      options = options.merge( :conditions => { :propia => convert_boolean(params['propia']) } )
    else
      options[:conditions] = {}
    end

    paginate(options)
  end


  # Presenta un listtado de importaciones
  # acumuladas, desde la vista
  def self.view_importaciones(page = 1)
    Marca.table_name = 'view_importaciones'

    Marca.send(:with_exclusive_scope) { 
      Marca.paginate(:page => page, 
                     :select => "importacion_id, SUM(total) AS total, SUM(errores) AS errores, estado",
                     :conditions => [ "importacion_id > ?", 0 ],
                     :group => "importacion_id")
    }
  end

  # Devuelve los registros y el estado
  def self.buscar_importados(fecha, valid = true)
    Marca.all(:conditions => { :fecha_importacion => fecha, :valido => valid }, :include => [ :clase, :tipo_signo ] )
  end


  # indica si hay errores en un listado
  # Debe ser un resultado de la tabla 'view_importaciones'
  # Marca.table_name = 'view_importaciones'
  def errores_listado
    if self.errores.to_i > 0
      "<span class=\"error b\">#{self.errores}</span>"
    else
      errores
    end
  end

  def self.historial(id, params = {})
    params = { :order => "updated_at DESC" }.merge(params)
    params[:conditions] = ["marcas.parent_id = ?", id]
    Marca.send(:with_exclusive_scope) { Marca.all(params) }
  end

  # Retorna todas las modificaciones realizadas a la marca
  def historial
    self.class.historial(self.id)
  end

  # Crea una instancia de acuerdo al estado
  # @param Hash parmas
  # @param Marca o modelo heredado Indica si se debe unir con los atributos de la clase
  # @return Marca.new o clase heredada
  def self.crear_instancia(params)
    set_include_estado(params[:estado])
    set_include_tipo_signo(params[:tipo_signo_id])
    #set_include_propia(params[:propia]) 
    new(params)
  end

  def set_include_propia(propia)
    if propia == "1"
      include ModMarca::Propia
    end
  end


  # Metodo para poder realizar actualizaciones
  # que pueda cambiar la clse y el estado
  def update_marca(params)
    self.class.set_include_estado(params[:estado])
    #set_include_tipo_signo(params[:tipo_signo_id])
    params[:valido] = true
    self.update_attributes(params)
  end


  def adicionar_errores(klass)
    klass.errors.each do |k, v|
     self.errors.add(k, v)
    end
  end

  # Retorna un url definido en marcas que solo sera para la misma
  def url
    if self.id.nil?
      "/marcas"
    else
      "/marcas/#{self.id}"
    end
  end

  # Realiza la busqueda de el cruce (busqueda) realizada para una marca
  #   @param Integer importacion_id
  #   @return Consulta
  def cruce(importacion_id)
    self.consultas.try(:find) { |v| v.importacion_id == importacion_id}
  end


  # Retorna los agentes desde el campo serializado
  #   @return Array
  def agentes_serial
    Representante.find(self.agente_ids_serial).map(&:nombre)
  end


  # Retorna los titulares desde el campo serializado
  #   @return Array
  def titulares_serial
    Representante.find(self.titular_ids_serial).map(&:nombre)
  end

  # Presenta los ultimos 3 posts o el parametro que se pase en limit
  #   @param Integer limit
  #   @return array
  def ultimos_posts()
    Post.all(:conditions => { :postable_id => self.id, :postable_type => 'Marca' }, 
             :limit => POSTS_SIZE, :order => 'created_at DESC' )
  end

  # Almacena los errores despues de que es fallida la validación
  def almacenar_errores
    self.errores = self.errors.inject([]) { |arr, v| arr << [v.first.humanize, v.last]; arr }
  end

  # Metodo simple para poder presentar errores serializados
  def presentar_errores
    arr = self.errores.inject([]) { |arr, v| arr << "<strong>#{v.first}</strong>: #{v.last}" }
    arr.join("<br />")
  end


  # Realiza una comparación de los datos que se importan Vs. los que se encuentran
  # en la base de datos, de lo contrario retorna una instancia
  #   @param Hash params
  #   @params Array comp # Array con datos tipo Symbol a comparar en una clase
  #   @return Marca
  def self.buscar_comparar_o_nuevo( params, comp )
    params[:nombre] = Marca.quitar_comillas( params[:nombre] )
    if params[:numero_solicitud].nil?
      marca = Marca.find_by_numero_registro(params[:numero_registro])
    else
      marca = Marca.find_by_numero_solicitud(params[:numero_solicitud])
    end
    
    if marca.nil?
      return Marca.new(params)
    elsif !(marca.propia)
      marca.attributes = params
      return marca
    end

    marca.importacion_id = params[:importacion_id]
    marca.errores_manual = {}

    comp.each do |m|
      if m.to_s =~ /^.*_ids$/
        unless marca[m].try(:sort) == params[m].try(:sort)
          marca.errores_manual[m] = "tiene valor distinto"
        end
      else
        #marca.errores_manual[m] = "#{TIPOS[params[:estado]]} con valor distinto: #{params[m]}" unless marca.send(m) == params[m]
        marca.errores_manual[m] = error_manual_comparacion(params[m])
      end
    end

    marca
  end

  def self.error_manual_comparacion(act)
    e2 = act.size <= 50 ? act : act[0,50] + '...'
    "tiene un valor diferente: #{e2}"
  end


  def self.quitar_comillas(txt)
    txt.gsub(/^(\342\200\234|"|\342\200\235)(.*)(\342\200\235|"|\342\200\234)$/, '\2').strip
  end

protected
  #########################################################
  # Metodos que ayudan para la extraccion de datos de Excel

  # Prepara el numero de solicitud para extraerlo
  #   @param String num
  #   @return String
  def self.preparar_numero_solicitud(num)
    num.gsub(/\s/, '').gsub(/–/, '-') unless num.nil?
  end
  
  def self.preparar_numero_solicitud_renovacion(num)
    num.gsub(/\s/, '').gsub(/–/, '-') unless num.nil?
  end

  def self.preparar_numero_registro(num)
    num.gsub(/\s/, '').gsub(/–/, '-') unless num.nil?
  end

  #   @param String
  def self.buscar_tipo_signo_id(tipo_signo_id)
    t = TipoSigno.find_by_nombre_or_sigla(tipo_signo_id, tipo_signo_id )
    t.id unless t.nil?
  end

  # Realiza la busqueda de una clase por su codigo
  #   @param
  def self.buscar_clase_id(clase_id)
    c = Clase.find_by_codigo(clase_id)
    c.id unless c.nil?
  end


private

  def quitar_comillas
    self.nombre = Marca.quitar_comillas(self.nombre)
  end

  def adicionar_usuario
    self.usuario_id = UsuarioSession.current_user[:id]
  end

  def set_minusculas
    self.nombre_minusculas = self.nombre.downcase.cambiar_acentos unless self.nombre.nil?
  end


  def crear_historico
    params = self.class.column_names.inject({}){ |hash, col| hash[col] = self.send(col); hash }.merge(:parent_id => self.id)
    params.delete(:id)
    m = self.class.new(params)
    self.changes.each{ |k, vals| m.send("#{k}=", vals.first) }
    m.save(false)
  end

  def set_cambios
    self.cambios =  self.changes.keys.select{ |v| not [:valido, :fila, :type, :nombre_minusculas].include?(v) }
  end

  # En caso de importación todas las marcas indica que no son propias a la empresa
  def set_propia
    self.propia = false if self.propia.nil?
  end

  def actualizar_validez
    if self.valido.nil?
      self.valido = true if self.errors.blank?
    end
  end

  # Copia datos denormalizados para poder tener en el historico
  # los datos de agentes relacionados y titulares relacionados
  def set_agentes_titulares
    self.agente_ids_serial = self.agente_ids
    self.titular_ids_serial = self.titular_ids
  end

  # Valida de que los campos de comparación esten vacios
  def validar_errores_manual
    unless self.errores_manual.blank?
      self.errores_manual.each do |k, v|
        self.errors.add(k, v)
      end
    end
  end

  # Llena el campo productos con la descripcion de la clase
  # en caso de que no hayan escrito nada
  def llenar_productos
    self.productos = self.clase.descripcion unless self.clase.nil?
  end

end
