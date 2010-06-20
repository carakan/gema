class Marca < ActiveRecord::Base

  before_save :actualizar_validez
  before_save :adicionar_usuario
  before_update :crear_historico

  belongs_to :clase
  belongs_to :tipo_signo
  belongs_to :tipo_marca
  belongs_to :usuario
  belongs_to :agente
  belongs_to :titular

  
  validates_presence_of :nombre, :estado_fecha, :estado, :tipo_signo_id, :clase_id
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

  # Columnas en archivo excel
  EXCEL_COLS = {
    :estado_fecha => 'A', # No es necesario dado que se ingresa la fecha
    :numero_solicitud => 'B',
    :nombre => 'E'
    # :tipo_signo_id => 'F',
    #:clase_id => 'G'
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

  #def self.all(*args)
  #  options = args.extract_options!
  #  super options#, :conditions => "marcas.parent_id = 0"
  #end

  # Presenta un listtado de importaciones
  # acumuladas, desde la vista
  def self.view_importaciones(page = 1)
    Marca.table_name = 'view_importaciones'
    marcas = Marca.send(:with_exclusive_scope) { Marca.paginate(:page => page) }
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

private
  def actualizar_validez
    self.valido = true if self.errors.blank?
  end

  def adicionar_usuario
    self.usuario_id = UsuarioSession.current_user[:id]
  end

  def crear_historico
    params = self.class.column_names.inject({}){ |hash, col| hash[col] = self.send(col); hash }.merge(:parent_id => self.id)
    params.delete(:id)
    m = self.class.new(params)
    self.changes.each{ |k, vals| m.send("#{k}=", vals.first) }
    m.save(false)
    self.cambios =  self.changes.keys.select{ |v| not [:valido, :fila, :type].include?(v) }
  end

end
