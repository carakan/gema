class SolicitudesController < ApplicationController
  # Verificacion si el usuario se ha logueado
  before_filter :authenticate_user!

  # Presenta la lista de importaciones
  def index
    @marcas = Marca.view_importaciones( @page )
  end

  def new
    @marca = ImportacionVacia.new(:tipo => params[:tipo])
  end

  # Creacion o actualizacion de marcas por tipo
  def create
    @marca = ImportacionVacia.new( params[:importacion_vacia] )
    if @marca.valid? == true
      fecha_importacion = Marca.importar(params[:importacion_vacia])
      redirect_to(importado_solicitud_url( fecha_importacion ) )
    else
      render :action => 'new'
    end
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
