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
  attr_accessible :login, :nombre, :email, :password, :password_confirmation, :remember_me, :rol_id

  has_many :marcas
  has_many :posts
  has_many :consultas
  has_many :importaciones
  belongs_to :area
  has_many :instruccion_detalles
  belongs_to :rol

  #validates_presence_of :login, :password
  validates_format_of :login, :with => /^[a-z0-9_-]{4,16}$/i
  #validates_uniqueness_of :login
  #validates_confirmation_of :password
  #validates_presence_of :password_confirmation, :if => :password_changed?

  def to_s
    nombre
  end
end
