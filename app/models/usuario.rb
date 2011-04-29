# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  # Se usa :login para poder autenticar
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :nombre, :email, :password, :password_confirmation, :remember_me, :rol_id, :area_id

  has_many :marcas
  has_many :posts
  has_many :consultas
  has_many :importaciones
  belongs_to :area, :class_name => "Proyecto::Area"
  has_many :instruccion_detalles
  belongs_to :rol

  #validates_presence_of :login, :password
  validates_format_of :login, :with => /^[a-z0-9_-]{4,16}$/i
  #validates_uniqueness_of :login
  #validates_confirmation_of :password
  #validates_presence_of :password_confirmation, :if => :password_changed?

  def self.all_for_areas
    result = []
    Proyecto::Area.all.each do |area|
      result << [area.nombre, area.usuarios.collect{|u| [u.nombre, u.id]}]
    end
    result
  end

  def is?(rol)
    self.rol.name == rol.to_s
  end

  def user_asignado(usuario)
    if self.id == usuario
      true
    end
  end

  def to_s
    nombre
  end
end
