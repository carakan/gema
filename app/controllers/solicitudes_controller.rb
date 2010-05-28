class SolicitudesController < ApplicationController
  def index
    @marca = Marca.new
  end

  def new
  end

  def create
    case params[:marca][:tipo]
      when 'sm' then @errors = SolicitudMarca.importar( params[:marca][:archivo] )
      when 'lp' then @errors = ListaPublicacion.importar( params[:marca][:archivo] )
      when 'lr' then
        # @errors = ListaRegistro.importar( params[:marca][:archivo] )
      when 'sr' then
        # @errors = SolicitudRenovacion.importar( params[:marca][:archivo] )
      when 'rc' then
        # @errors = ListaPublicacion.importar( params[:marca][:archivo] )
    end

  end
end
