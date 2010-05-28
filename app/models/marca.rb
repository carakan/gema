# encoding:utf-8
class Marca < ActiveRecord::Base
  belongs_to :clase
  
  validates_presence_of :nombre


  TIPOS = { "Solicitud de Marca" => "sm",
    "Lista de publicación" => "lp",
    "Lista de Registro" => "lr", 
    "Solicitud de Renovación" => "sr", 
    "Renovaciones Concedidas" => "rc" }

  # Columnas en archivo excel
  EXCEL_COLS = {
    :estado_fecha => 'A',
    :sm => 'B',
    :nombre => 'E',
    :tipo_marca_id => 'G'
  }

  # Extra para poder importar
  attr_accessor :tipo, :archivo

  def to_s
    nombre
  end
end
