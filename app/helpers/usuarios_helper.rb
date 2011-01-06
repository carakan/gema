module UsuariosHelper
  def edit_usuario?
    ["edit", "update"].include? params[:action]
  end

  # Retorna la url de acuerdo si es una actualizacion o creacion de usuario
  # @param Usuario
  def usuario_form_path(usuario)
    if usuario.id.nil?
      create_usuario_usuario_path(0)
    else
      update_usuario_usuario_path(usuario.id)
    end
  end
end
