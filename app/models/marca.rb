class Marca < ActiveRecord::Base
  belongs_to :clase
  belongs_to :tipo_marca
  #belongs_to :usuario
  #belongs_to :agente
  #belongs_to :titular

  
  validates_presence_of :nombre, :estado_fecha, :estado, :tipo_marca_id
  validates_format_of :numero_solicitud, :with => /^\d+-\d{4}$/
  validates_uniqueness_of :numero_solicitud

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

  def self.ver_estado(est)
    TIPOS[est]
  end

  # Presenta un listtado de importaciones
  def self.importaciones(page = 1)
    total = Marca.all(:select => 'COUNT(*) as total', :group => 'fecha_importacion').size

    sql = 'SELECT fecha_importacion, SUM(total) AS total, SUM(errores) AS errores, estado FROM
    (
      SELECT fecha_importacion, COUNT(*) AS total, 0 as errores, estado FROM marcas 
      UNION
      SELECT fecha_importacion, 0 AS total, COUNT(*) as errores, estado FROM marcas WHERE valido = ?
    ) AS importaciones GROUP BY fecha_importacion ORDER BY fecha_importacion'
    if total > 0
      self.find_by_sql( [sql, false] )
    else
      []
    end
  end

end
