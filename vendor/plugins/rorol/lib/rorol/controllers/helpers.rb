# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
module Rorol
  module Controllers
    module Helpers
      
      #def self.included(base)
      #  base.send(:include, InstanceMethods)
      #end

      #module InstanceMethods
      #  # Verifica de que el permiso sea correcto
      #  # Mucho cuidado con UsuarioSession usado para la verificacion
      #  def revisar_permiso!
      #    #rol_id = UsuarioSession.current_user[:rol_id]
      #    #debugger
      #    permission = Permission.find_by_rol_id_and_controller( UsuarioSession.current_user[:rol_id], params[:controller] )

      #    if permission
      #      redirect_to "/" unless permission.actions[ params[:action] ]
      #    else
      #      redirect_to '/logout'
      #    end
      #  end
      #end
    end

  end
end
