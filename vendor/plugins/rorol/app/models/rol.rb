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

  # Updates the privileges based on the query from the database
  def set_privileges
    lista = [] # Variable para almacenar temporalmente los nuevos permisos
    Rol.routes.each do |cont|
      # Asignacion a dos variables para no confundirse
      controller, actions = cont.first, cont.last
      permission = permissions[permissions.index { |p| p.controller == controller }]

      if permission
        # Delete the ones that don't exists
        (permission.actions.keys - actions.keys).each { |v| permission.actions.delete(v) }
        permission.actions = actions.merge( permission.actions )
      else
        self.permissions_attributes = [ { :controller => controller, :actions => actions } ]
      end
    end
  end

  class << self

    # List the routes in an array like this
    #   ["reportes", {"index"=>false, "create"=>false}]
    def routes(default = false)
      ActionDispatch::Routing::Routes.routes.map do |r| 
        [ r.requirements[:controller], r.requirements[:action] ]
      end.group_by(&:first).map { |v| [ v.first, Hash[v.last.map { |val| [val.last, default] }] ] }
    end

    # Returns a hash of controllers
    def hash_controllers_actions(allow = false)
      routes(allow).map { |v| { :controller => v.first, :actions => v.last } }
    end

  end

end
