class SolicitudesController < ApplicationController
  def index
    @marca = Marca.new
  end

  def new
  end

  def create
    case params[:marca][:tipo]
      when 'sm'
        @errors, @tot = SolicitudMarca.importar( params[:marca][:archivo] )
      when 'lp'
        @tot, @errors = ListaPublicacion.importar( params[:marca][:archivo] )
      when 'lr'
        # @errors = ListaRegistro.importar( params[:marca][:archivo] )
      when 'sr'
        # @errors = SolicitudRenovacion.importar( params[:marca][:archivo] )
      when 'rc'
        # @errors = ListaPublicacion.importar( params[:marca][:archivo] )
    end
  end
end
