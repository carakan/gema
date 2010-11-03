# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Permission < ActiveRecord::Base
  before_save :set_actions_values!

  belongs_to :rol
  serialize :actions

  validates_presence_of :controller#, :rol_id # No se debe activar esta validación de lo contrario creara problemas
  validates_associated :rol

  # Actualiza los valores de las acciones para que sean true, false
  # en ves de "0" o "1"
  def set_actions_values!
    actions.each{ |k, v|
      val = false
      val = true if v == "1" or v == true
      actions[k] = val
    }
  end

  class << self
    # Verifica si un usuario tiene permiso al controlador y la acción
    def permite_ruta?(controller, accion)
      p = Permission.find_by_rol_id_and_controller(current_user.rol_id, controller)
      p.acciones[accion]
    end

    def current_user
      UsuarioSession.current_user
    end

    # Para poder buscar los permisos de un usuario en un controller
    def controller(cont)
      Permiso.find_by_controller_and_rol_id(cont, Permission.current_user.rol_id)
    end
  end

end
