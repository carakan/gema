class SolicitudesController < ApplicationController
  # Verificacion si el usuario se ha logueado
  before_filter :authenticate_user!

  # Presenta la lista de importaciones
  def index
    @marcas = Marca.view_importaciones()
  end

  def new
    @marca = Marca.new( :fecha_gen => Date.today )
  end

  # Creacion o actualizacion de marcas por tipo
  def create
    case params[:tipo]
      when 'sm'
        fecha_importacion = SolicitudMarca.importar( params[:marca][:archivo] )
        redirect_to(importado_solicitud_url( fecha_importacion ) )
      when 'lp'
        @tot, @errors = ListaPublicacion.importar( params[:marca][:archivo] )
        redirect_to(importado_solicitud_url( fecha_importacion ) )
      when 'lr'
        # @errors = ListaRegistro.importar( params[:marca][:archivo] )
      when 'sr'
        # @errors = SolicitudRenovacion.importar( params[:marca][:archivo] )
      when 'rc'
        # @errors = ListaPublicacion.importar( params[:marca][:archivo] )
    end
  end


  # Presenta el listado de una importacion realizada
  def importado
    @mostrar = 'error'
    d = DateTime.parse(params[:id]) + (Time.zone.utc_offset * -1).seconds

    @mostrar = params[:mostrar] unless params[:mostrar].nil?
    @marcas = Marca.buscar_importados( d, false ) if @mostrar == 'error'

    @total = @marcas.size
    if @total == 0 or @mostrar == 'all'
      @marcas = Marca.buscar_importados(d)
      @mostrar = 'all'
      @marcas = @marcas.paginate(:page => @page)
    end

    @path_proc = path_proc(@marcas.first)

  end

private
  # Sirve para poder identificar el tipo de importacion (lista)
  # realizado
  def path_proc(marca)
    case marca.estado
      when 'sm' then lambda{ |m| edit_solicitud_marca_path(m) }
      when 'lp' then lambda{ |m| edit_lista_publicacion_path(m) }
    end
  end

end
