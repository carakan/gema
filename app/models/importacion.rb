class Importacion < ActiveRecord::Base

  has_many :marcas, :dependent => :destroy

  default_scope :conditions => { :completa => true }
end
