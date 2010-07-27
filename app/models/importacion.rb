class Importacion < ActiveRecord::Base

  has_many :marcas, :dependent => :destroy

  default_scope :conditions => { :completa => true }

  has_attached_file :archivo, :path => ":rails_root/public/system/:rails_env/importaciones/:id_partition/:filename"
end
