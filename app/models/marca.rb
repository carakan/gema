class Marca < ActiveRecord::Base

  #before_save :set_propia
  before_save :set_minusculas
  before_save :adicionar_usuario
  before_update :crear_historico
  before_save :actualizar_validez

  belongs_to :clase
  belongs_to :tipo_signo
  belongs_to :tipo_marca
  belongs_to :usuario
  belongs_to :agente
  belongs_to :titular

  
  validates_presence_of :nombre, :estado_fecha, 
    :estado, :tipo_signo_id, :clase_id

  validates_format_of :numero_solicitud, :with => /^\d+-\d{4}$/
  validates_uniqueness_of :numero_solicitud, :scope => :parent_id


  serialize :cambios

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
    Marca.all(:conditions => { :fecha_importacion => fecha, :valido => valid }, :include => [ :clase, :agente, :tipo_signo ] )
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
    Marca.send(:with_exclusive_scope) { Marca.all(:conditions => ["marcas.parent_id = ?", id]) }
  end


  # Crea una instancia de acuerdo al estado
  # @param Hash parmas
  # @param Marca o modelo heredado Indica si se debe unir con los atributos de la clase
  # @return Marca.new o clase heredada
  def self.crear_instancia(params, klass = nil)
    params = extraer_params(params)
    params = klass.attributes.merge(params) unless klass.nil?
    case params[:estado]
      when 'sm' then SolicitudMarca.new(params)
      when 'lp' then ListaPublicacion.new(params)
        # when'lr' then ListaRegistro.new(params)
        # when'sr' then SolicitudRenovación.new(params)
        # when 'rc' then RenovacionesConcedidas.new(params)
      else
        new(params)
    end
  end

  # extrae los parametros correctos de acuerdo al estado
  def self.extraer_params(params)
    return params[:marca] unless params[:marca].nil?
    return params[:solicitud_marca] unless params[:solicitud_marca].nil?
    return params[:lista_publicacion] unless params[:lista_publicacion].nil?
    return params[:lista_registro] unless params[:lista_registro].nil?
    return params[:solicitud_renovacion] unless params[:solicitud_renovacion].nil?
    return params[:renovacion_concedida] unless params[:renovacion_concedida].nil?
  end

  # Metodo para poder realizar actualizaciones
  # que pueda cambiar la clse y el estado
  def update_marca(params)
    klass = self.class.crear_instancia(params, self)
    # Se asigna los atributos para no perder datos de los params
    self.attributes = klass.attributes
    # se asigna datos faltantes para klass
    klass.estado_fecha = Date.today
    klass.numero_solicitud = '0000-0000'
    # Se cambia el estado y la clase de Marca
    self.estado = klass.estado
    self.type = klass.type
    # Cambiar fecha si es que se cambio el estado
    # self.estado_fecha = Date.today unless self.changes['estado'].nil?

    if klass.valid?
      return self.save
    else
      adicionar_errores(klass)
      return false
    end
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

private

  def adicionar_usuario
    self.usuario_id = UsuarioSession.current_user[:id]
  end

  def set_minusculas
    self.nombre_minusculas = self.nombre.downcase
  end

  def crear_historico
    params = self.class.column_names.inject({}){ |hash, col| hash[col] = self.send(col); hash }.merge(:parent_id => self.id)
    params.delete(:id)
    m = self.class.new(params)
    self.changes.each{ |k, vals| m.send("#{k}=", vals.first) }
    m.save(false)
    self.cambios =  self.changes.keys.select{ |v| not [:valido, :fila, :type].include?(v) }
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

end
