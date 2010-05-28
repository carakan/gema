class Clase < ActiveRecord::Base

  has_many :marcas

  validates_presence_of :nombre, :codigo
  validates_numericality_of :codigo
  validates_uniqueness_of :codigo

  def to_param
    %(#{codigo} - #{nombre})
  end

  def to_s
    to_param
  end

end
