module UsuariosHelper
  def edit_usuario?
    ["edit", "update"].include? params[:action]
  end
end
