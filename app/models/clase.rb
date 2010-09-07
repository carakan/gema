# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Clase < ActiveRecord::Base

  has_many :marcas

  validates_presence_of :nombre, :codigo
  validates_numericality_of :codigo
  validates_uniqueness_of :codigo


  def to_s
    nombre
  end

end
