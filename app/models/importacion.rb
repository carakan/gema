class Importacion < ActiveRecord::Base

  has_many :marcas

  default_scope :conditions => { :completa => true }
end
