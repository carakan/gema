class SolicitudesController < ApplicationController
  def index
    @marca = Marca.new( :fecha_gen => Date.today )
  end

  def new
    @marca = Marca.new( :fecha_gen => Date.today )
  end

  def create
    case params[:marca][:tipo]
      when 'sm'
        @errors, @tot = SolicitudMarca.importar( params[:marca][:archivo], params[:marca][:fecha_gen] )
      when 'lp'
        @tot, @errors = ListaPublicacion.importar( params[:marca][:archivo] )
        redirect_to("/lista")
      when 'lr'
        # @errors = ListaRegistro.importar( params[:marca][:archivo] )
      when 'sr'
        # @errors = SolicitudRenovacion.importar( params[:marca][:archivo] )
      when 'rc'
        # @errors = ListaPublicacion.importar( params[:marca][:archivo] )
    end

    #if @tot == false
    #  flash[:error] = @errors
    #  render :action => 'new'
    #else
    #  redirect_to solicitud_path(1)
    #end
  end
end
