# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
# Modelo sin tabla que solo sirve para poder
# realizar validaciones de los datos
class ImportacionVacia < Tableless
  column :archivo, :string
  column :formato_fecha
  column :publicacion
  column :publicacion_fecha
  column :tipo

  validates_inclusion_of :tipo, :in => Marca::TIPOS.keys, :message => 'Tipo inexistente'
  validates_presence_of :archivo
  validates_presence_of :publicacion, :if => :ver_gaceta?
  validates_numericality_of :publicacion, :if => :ver_gaceta?
  #validates_presence_of :publicacion_fecha, :if => :ver_gaceta?
  validate :fecha_valida

  FORMATOS_FECHA = [
    ["dia mes año", "d-m-y"],
    ["mes dia año", "m-d-y"],
    ["año mes dia", "y-m-d"]
  ]

  #attr_accessor :tipo

  def after_initialize
    self.errors.add(:tipo, 'Tipo inexistente') unless Marca::TIPOS.keys.include?(tipo)
  end

  def importar( params )
    case self.tipo
      when 'sm'
        fecha_importacion = SolicitudMarca.importar( params[:archivo] )
      when 'lp'
        fecha_importacion = ListaPublicacion.importar( params[:archivo] )
      when 'lr'
        fecha_importacion = ListaRegistro.importar( params[:marca][:archivo] )
      when 'sr'
        fecha_importacion = SolicitudRenovacion.importar( params[:marca][:archivo] )
      when 'rc'
        # fecha_importacion = ListaPublicacion.importar( params[:marca][:archivo] )
    end
  
    fecha_importacion
  end

  def self.set_validaciones(tipo, params)
    #new(params.merge(:tipo => tipo) )
  end

  def ver_tipo
    Marca::TIPOS[self.tipo]
  end

private
  # Permite determinar atributos extra que deben ser validados
  def ver_gaceta?
    case tipo
      when 'lp' then true
      else 
        false
    end
  end

  def fecha_valida
    begin
      Date.parse(self.publicacion_fecha)
    rescue
      self.errors.add(:publicacion_fecha, "Debe ingresar un fecha válida")
    end
  end
end
