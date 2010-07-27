class Pais < ActiveRecord::Base
  has_many :marcas
  has_many :representantes

  validates_presence_of :nombre, :codigo
  validates_uniqueness_of :codigo

  def to_s
    "#{codigo} - #{nombre}"
  end
end
