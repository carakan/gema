class Marca < ActiveRecord::Base
  belongs_to :clase
  
  validates_presence_of :nombre, :estado_fecha, :estado, :tipo_marca_id
  validates_format_of :numero_solicitud, :with => /^\d+-\d{4}$/

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
    :nombre => 'E',
    # :tipo_marca_id => 'F',
    :clase_id => 'G'
  }

  # Extra para poder importar
  attr_accessor :tipo, :archivo, :fecha_gen

  def to_s
    nombre
  end

  def ver_estado
    TIPOS[estado]
  end

end
