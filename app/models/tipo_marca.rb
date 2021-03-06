# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class TipoMarca < ActiveRecord::Base
  has_many :marcas
  validates_presence_of :nombre

  def to_s
    nombre
  end
end
