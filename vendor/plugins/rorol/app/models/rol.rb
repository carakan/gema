# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Rol < ActiveRecord::Base
  has_many :permissions, :dependent => :destroy

  accepts_nested_attributes_for :permissions, :allow_destroy => true

  validates_presence_of :name

  cattr_reader :per_page
  @@per_page = 30

  def to_s
    name
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
      controller, actions = cont[0], cont[1]
      # Busqueda del permiso con el mismo controlador
      permission = permissions.select{ |per| controller == per.controller }[0]
      if permission
        tmp = {}
        # Iterar acciones del controlador no del permiso
        actions.each do |k,v|
          tmp[k] = permission.actions[k] # Se asignara true si es que exite la accion en permisos y su valor sea true
        end
        # asignacion de las acciones al permiso, esto por que puede ser
        # que se hayan cambiado las acciones del controlador y se tengan nuesvas acciones
        permission.actions = tmp
      else
        # Adición del nuevo controlador en caso de que no exista
        self.permissions_attributes = [ { :controller => cont[0], :action => cont[1] } ]
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
    def routes
      ActionDispatch::Routing::Routes.routes.map { |r| [ r.requirements[:controller], r.requirements[:action] ]}.group_by do |v|
        v.first
      end.inject([]) { |arr, v| arr << { v.first => v.last.map(&:last).inject({}) { |h, val| h[val.to_sym] = false; h } }; arr }
    end

    def hash_controllers_actions
      routes.map { |c| { :controller => c.keys.first, :actions => c.values.first }  }
      #list_controllers.map { |c| {:controlador => c.first, :acciones => c.last} }
    end

  end

end
#{:controlador=>"adjuntos", :acciones=>{:create=>false, :destroy=>false, :edit=>false, :index=>false, :new=>false, :show=>false, :update=>false}}
