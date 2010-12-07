# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class TipoSigno < ActiveRecord::Base
  has_many :marcas

  validates_presence_of :nombre

  def self.find_by_nombre_or_sigla(nombre, sigla)
    self.first( :conditions => ["nombre = ? OR sigla = ?", nombre, sigla] )
  end

  def to_s
    nombre
  end

  # ids de marcas descartadas para el cruce
  #   @return Array
  def self.descartadas_cruce
    #['Figurativa', 'Tridimensional'].map{ |v| find_by_nombre(v).try(:id) }
    [2, 4]
  end
end
