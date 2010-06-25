class ListaPublicacionesController < ApplicationController
  # Presenta la lista de importaciones
  def index
    @marcas = ListaPublicacion.view_importaciones()
  end

  def new
    @marca = ListaPublicacion.new( :fecha_gen => Date.today )
  end

  # Creacion o actualizacion de marcas por tipo
  def create
    @tot, @errors = ListaPublicacion.importar( params[:marca][:archivo] )
    redirect_to(importado_solicitud_url( fecha_importacion ) )
  end


  # Presenta el listado de una importacion realizada
  def importado
    @mostrar = 'error'
    d = DateTime.parse(params[:id]) + (Time.zone.utc_offset * -1).seconds

    @mostrar = params[:mostrar] unless params[:mostrar].nil?
    @marcas = Marca.buscar_importados( d, false ) if @mostrar == 'error'

    if @total == 0 or @mostrar == 'all'
      @marcas = Marca.buscar_importados(d)
      @mostrar = 'all'
      @marcas = @marcas.paginate(:page => @page)
    end
  end
end
