# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Importacion < ActiveRecord::Base

  before_create :adicionar_usuario

  belongs_to :usuario

  has_many :marcas, :dependent => :destroy
  has_many :consultas
  has_many :reporte_marcas

  default_scope :conditions => { :completa => true }


  has_attached_file :archivo, :path => ":rails_root/public/system/:rails_env/importaciones/:id_partition/:filename"

  # Realiza el conteo de cruces que se realizaron y lo actualiza (dato denormalizado)
  def inicializar_cruces_pendientes
    cruces = buscar_cruces_pendientes
    self.update_attributes(:cruces_pendientes => cruces) unless self.cruces_pendientes == cruces
  end

  # Metodo para presentar una gaceta
  def gaceta
    %Q(gaceta #{publicacion} del #{I18n.l publicacion_fecha})
  end

  def gaceta?
    self.tipo == "lp"
  end

private

  # Retorna la cantidad de cruces pendientes de una importacion
  #   @return Integer
  def buscar_cruces_pendientes
    cruces = Marca.all(:select => "id", :conditions =>  [
      "marcas.importacion_id = ? AND marcas.propia = ? AND marcas.tipo_signo_id NOT IN (?)", 
        self.id, false, TipoSigno.descartadas_cruce
    ]).size

    cruces - self.consultas.size
  end

  def adicionar_usuario
    self.usuario_id = UsuarioSession.current_user[:id]
  end
end
