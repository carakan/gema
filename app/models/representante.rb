class Representante < ActiveRecord::Base
  before_validation :set_validar
  #before_save :strip_data

  belongs_to :pais

  validates_presence_of :nombre
  validates_format_of :email, :with => Constants::EMAIL_REG, 
    :unless => lambda{ |r| r.email.blank? }

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
