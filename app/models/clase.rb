class Clase < ActiveRecord::Base

  has_many :marcas

  validates_presence_of :nombre, :codigo
  validates_numericality_of :codigo
  validates_uniqueness_of :codigo

  def to_s
    nombre[6..-1]
  end

end
