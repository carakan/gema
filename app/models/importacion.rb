class Importacion < ActiveRecord::Base

  has_many :marcas, :dependent => :destroy
  has_many :consultas

  default_scope :conditions => { :completa => true }

  has_attached_file :archivo, :path => ":rails_root/public/system/:rails_env/importaciones/:id_partition/:filename"

  # Realiza el conteo de cruces que se realizaron y actualiza según el número
  def inicializar_cruces_pendientes
    if self.cruces_pendientes < 0
      cruces = Marca.cruce(self.id).size
      self.update_attributes(:cruces_pendientes => cruces)
    end
  end
end
