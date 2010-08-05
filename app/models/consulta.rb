class Consulta < ActiveRecord::Base
  before_save :adicionar_usuario

  belongs_to :marca
  belongs_to :usuario


private
  def adicionar_usuario
    self.usuario_id = UsuarioSession.current_user[:id]
  end

  # Almacena el reporte creado por la consulta
  def almacenar_reporte
    self.reporte = ''
  end

end
