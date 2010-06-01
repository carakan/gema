class SolicitudesController < ApplicationController
  def index
    @marca = Marca.new( :fecha_gen => Date.today )
  end

  def new
  end

  def create
    fecha =(1..3).inject([]){ |a, v| a << params[:marca]["fecha_gen(#{v}i)"] }.join("-") 
    case params[:marca][:tipo]
      when 'sm'
        @errors, @tot = SolicitudMarca.importar( params[:marca][:archivo], fecha )
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
