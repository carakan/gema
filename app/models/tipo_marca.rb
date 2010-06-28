class TipoMarca < ActiveRecord::Base
  has_many :marcas

  def to_s
    nombre
  end
end
