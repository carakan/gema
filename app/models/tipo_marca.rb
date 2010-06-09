class TipoMarca < ActiveRecord::Base
  has_many :marcas

  validates_presence_of :nombre

  def self.find_by_nombre_or_sigla(nombre, sigla)
    self.first( :conditions => ["nombre = ? OR sigla = ?", nombre, sigla] )
  end

  def to_s
    nombre
  end
end
