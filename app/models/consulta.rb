class Consulta < ActiveRecord::Base
  before_save :adicionar_usuario

  belongs_to :marca
  belongs_to :usuario

  has_many :consulta_detalles, :dependant => :destroy
  accepts_nested_attributes_for :consulta_detalles


  serialize :parametros

  # Convierte los parametros que se utilizaron en la busqueda
  # como las clases, rangos de fechas y otros a un hash
  def self.convertir_parametros_a_hash(params)
    hash = { :clases => params[:clases].split(",").map(&:to_i) }
  end

private
  def adicionar_usuario
    self.usuario_id = UsuarioSession.current_user[:id]
  end

  # Almacena el reporte creado por la consulta
  def almacenar_reporte
    self.reporte = ''
  end

end
