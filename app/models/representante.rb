class Representante < ActiveRecord::Base
  before_validation :set_validar
  #before_save :strip_data

  validates_presence_of :nombre, :if => :validar
  validates_presence_of :email, :if => :validar
  validates_format_of :email, :with => EMAIL_REG, :if => :validar

  attr_accessor :validar

  def to_s
    nombre
  end

private
  # Prepara el atributo validar
  def set_validar
    self.validar = true if validar.nil?
  end

  #def strip_data
  #  [:nombre, :email, :direccion, :telefono, :movil].each do |v|
  #    self.send("#{v}=", send(v).strip) unless self.send(v).nil?
  #  end
  #end

end
