# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Contacto < ActiveRecord::Base
  belongs_to :representante
  
  has_and_belongs_to_many :proyectos, :join_table => :proyectos_contactos
  validates_presence_of :nombre, :cargo, :telefono
  validates :email, :presence => true, :email => true
  #validates_format_of :email, :with => Constants::EMAIL_REG, :unless => lambda { |c| c.email.blank? }
  def to_s
   self.nombre	
  end
  	 
end

