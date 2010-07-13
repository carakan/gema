# encoding: utf-8
class Marca < ActiveRecord::Base

  #before_save :set_propia
  before_save :set_minusculas
  before_save :adicionar_usuario
  before_save :set_agentes_titulares, :if => lambda{ |m| m.parent_id == 0 }

  before_update :crear_historico
  before_update :set_cambios
  before_save :actualizar_validez

  belongs_to :clase
  belongs_to :tipo_signo
  belongs_to :tipo_marca
  belongs_to :usuario

  has_many :posts, :order => 'created_at DESC'

  has_and_belongs_to_many :agentes, :class_name => 'Agente',
    :association_foreign_key => :representante_id,
    :join_table => 'marcas_representantes'
  has_and_belongs_to_many :titulares, :class_name => 'Titular',
    :association_foreign_key => :representante_id,
    :join_table => 'marcas_representantes'


  # Las validaciones se guardan en los modulos 

  # Serializaciones, Denormalizacion de datos
  serialize :cambios
  serialize :agente_ids_serial
  serialize :titular_ids_serial


  validates_presence_of :estado

  default_scope :conditions => "marcas.parent_id = 0"

  named_scope :importados, lambda{ |fecha| 
    { :conditions => { :fecha_importacion => fecha} } 
  }

  named_scope :importados_error, lambda{ |fecha| 
    { :conditions => { :fecha_importacion => fecha, :valido => false} } 
  }

  TIPOS = {
    'sm' => 'Solicitud de Marca',
    'lp' => 'Lista de publicación',
    'lr' => 'Lista de Registro',
    'sr' => 'Solicitud de Renovación',
    'rc' => 'Renovaciones Concedidas'
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

  def ver_fila
    "El error fue encontrado en la fila #{fila} del archivo importado" if fila and valido == false
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
    set_include(params[:tipo])
    importar_archivo(params)
  end

  def self.set_include(tipo)
    case tipo
      when 'sm'
        include ModMarca::Solicitud
      when 'lp'
        include ModMarca::ListaPublicacion
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

  def self.buscar(*args)
    options = args.extract_options!
    params = options.delete(:params)
    
    unless params['propia'].nil?
      options = options.merge(:conditions => { :propia => convert_boolean(params['propia']) })
    else
      options[:conditions] = {}
    end

    paginate(options)
  end

  #def self.all(*args)
  #  options = args.extract_options!
  #  super options#, :conditions => "marcas.parent_id = 0"
  #end

  # Presenta un listtado de importaciones
  # acumuladas, desde la vista
  def self.view_importaciones(page = 1)
    Marca.table_name = 'view_importaciones'
    marcas = Marca.send(:with_exclusive_scope) { 
      Marca.paginate(:page => page, 
                     :select => "fecha_importacion, SUM(total) AS total, SUM(errores) AS errores, estado",
                     :group => "fecha_importacion") 
    }
    marcas
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

  def self.historial(id)
    Marca.send(:with_exclusive_scope) { Marca.all(:conditions => ["marcas.parent_id = ?", id], :order => "updated_at DESC") }
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
    set_include(params[:estado])
    Marca.new(params)
  end


  # Metodo para poder realizar actualizaciones
  # que pueda cambiar la clse y el estado
  def update_marca(params)
    self.class.set_include(params[:estado])
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

  # Retorna los agentes desde el campo serializado
  #   @return Array
  def agentes_serial
    Agente.find(self.agente_ids_serial).map(&:nombre)
  end


  # Retorna los titulares desde el campo serializado
  #   @return Array
  def titulares_serial
    Titular.find(self.titular_ids_serial).map(&:nombre)
  end

  # Presenta los ultimos 3 posts o el parametro que se pase en limit
  #   @param Integer limit
  #   @return array
  def ultimos_posts(limit = 3)
    Post.all(:conditions => { :marca_id => self.id }, 
             :limit => limit, :order => 'created_at DESC' )
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

end
