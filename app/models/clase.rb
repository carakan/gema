class Clase < ActiveRecord::Base

  has_many :marcas

  validates_presence_of :nombre, :codigo
  validates_numericality_of :codigo
  validates_uniqueness_of :codigo

  validates_format_of :uno, :with => /abc/


  def to_s
    %(#{codigo} - #{nombre})
  end

end
