# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Rol < ActiveRecord::Base
  has_many :permisos, :dependent => :destroy

  accepts_nested_attributes_for :permisos, :allow_destroy => true

  validates_presence_of :nombre

  cattr_reader :per_page
  @@per_page = 30

  def to_s
    nombre
  end

  # Actualiza los valores de permisos basado en a lista de controladores
  # en caso de que no exita algun valor no es tomado en cuenta
  def actualizar
    # Iterar a traves de la lista de controladores
    # es necesario verificar esto por que pueden cambiar sin aviso y se debe comparar
    # contra los valores que ya existen en permisos de un rol
    lista = [] # Variable para almacenar temporalmente los nuevos permisos
    Rol.list_controllers.each do |cont|
      # Asignacion a dos variables para no confundirse
      controlador, acciones = cont[0], cont[1]
      # Busqueda del permiso con el mismo controlador
      permiso = permisos.select{ |per| controlador == per.controlador }[0]
      if permiso
        tmp = {}
        # Iterar acciones del controlador no del permiso
        acciones.each do |k,v|
          tmp[k] = permiso.acciones[k] # Se asignara true si es que exite la accion en permisos y su valor sea true
        end
        # asignacion de las acciones al permiso, esto por que puede ser
        # que se hayan cambiado las acciones del controlador y se tengan nuesvas acciones
        permiso.acciones = tmp
      else
        # Adición del nuevo controlador en caso de que no exista
        self.permisos_attributes = [ { :controlador => cont[0], :acciones => cont[1] } ]
      end
    end
  end

  class << self
    # Lista todos los controladores y acciones de la aplicacion
    # Retorna un array con dos elementos de array donde el primer elemento
    # es el controlador y el segundo es un hash con las acciones y valores por defecto "false"
    # Ejemplo:
    #   [["uno", {"index" => false}], ["dos", {"index" => false}]]
    def list_controllers
      controllers = Dir.glob("#{Rails.root}/app/controllers/*_controller.rb").map { |v| File.basename v }.sort
      controllers.delete("application_controller.rb")

      controllers.inject([]) do |arr, controller|
        cont = controller.gsub(/\.rb$/, '').classify.constantize.new
        actions = (cont.methods - cont.private_methods - cont.protected_methods - ApplicationController.new.methods).sort
        arr << [controller.gsub(/_controller\.rb/, ''), actions.inject({}) { |h, v| h[v] = false; h} ]
      end
    end

    # Listado de rutas
    def rutas
      act = ActionDispatch::Routing::Routes.routes.first.requirements[:controller]
      ActionDispatch::Routing::Routes.routes.map do |v|
         "#{ v.requirements[:controller] }##{ v.requirements[:action]}"
      end
    end

    def hash_controladores_acciones
      list_controllers.map { |c| {:controlador => c.first, :acciones => c.last} }
    end

  end

end
