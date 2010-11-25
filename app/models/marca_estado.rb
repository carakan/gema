# encoding: utf-8
class MarcaEstado < ActiveRecord::Base
  has_many :marcas

  # lista los modulos en lib/mod_marca
  def self.listar_modulos
    Dir.chdir("#{Rails.root}/lib")
    Dir.glob("mod_marca/*.rb").map { |v| v.slice(0, v.size - 3).classify }
  end

  MODULOS = MarcaEstado.listar_modulos

  validates_presence_of :nombre
  validates_inclusion_of :modulo, :in => MODULOS

  def to_s
    nombre
  end

  # busca el estado que se relaciona con la importacion
  def self.buscar_estado(estado)
    case estado
    when 'sm'
      ModMarca::Solicitud
    when 'lp'
      ModMarca::ListaPublicacion
    when 'lr'
      ModMarca::ListaRegistro
    when 'sr'
      ModMarca::SolicitudRenovacion
    when 'rc'
      ModMarca::RenovacionConcedida
    end
  end

end
