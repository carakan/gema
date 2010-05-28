class SolicitudesController < ApplicationController
  def index
    @marca = Marca.new
  end

  def new
  end

  def create
    case params[:marca][:tipo]
      when 'sm' then @tot, @errors = SolicitudMarca.importar( params[:marca][:archivo] )
      when 'lp' then @tot, @errors = ListaPublicacion.importar( params[:marca][:archivo] )
      when 'lr' then
        # @errors = ListaRegistro.importar( params[:marca][:archivo] )
      when 'sr' then
        # @errors = SolicitudRenovacion.importar( params[:marca][:archivo] )
      when 'rc' then
        # @errors = ListaPublicacion.importar( params[:marca][:archivo] )
    end
  end
end
