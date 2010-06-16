class Marca < ActiveRecord::Base

  before_save :actualizar_validez

  belongs_to :clase
  belongs_to :tipo_marca
  belongs_to :usuario
  belongs_to :agente
  belongs_to :titular

  
  validates_presence_of :nombre, :estado_fecha, :estado, :tipo_marca_id
  validates_format_of :numero_solicitud, :with => /^\d+-\d{4}$/
  validates_uniqueness_of :numero_solicitud

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
    # :tipo_marca_id => 'F',
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

  # Presenta un listtado de importaciones
  # acumuladas, desde la vista
  def self.view_importaciones(page = 1)
    Marca.table_name = 'view_importaciones'
    marcas = Marca.paginate(:page => page)
    marcas
    #total = Marca.all(:select => 'COUNT(*) as total', :group => 'fecha_importacion').size

        #if total > 0
    #  self.find_by_sql( [sql, false] )
    #else
    #  []
    #end
  end

  # Devuelve los registros y el estado
  def self.buscar_importados(fecha, valid = true)
    Marca.all(:conditions => { :fecha_importacion => fecha, :valido => valid }, :include => :clase, :include => :agente )
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

private
  def actualizar_validez
    self.valido = true if self.errors.blank?
  end

end
