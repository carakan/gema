class SolicitudesController < ApplicationController
  # Presenta la lista de importaciones
  def index
    @marcas = Marca.importaciones()
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
    conditions = { :fecha_importacion => d } 

    @mostrar = params[:mostrar] unless params[:mostrar].nil?
    case @mostrar
      when 'all'
        @marcas = Marca.paginate( :conditions => conditions, :page => @page )
      when 'valid'
        @marcas = Marca.paginate( :conditions => conditions.merge( :valido => true ), :page => @page )
      else
        @marcas = Marca.all( :conditions => conditions.merge( :valido => false ) )
    end

    @total = Marca.all( :conditions =>  { :fecha_importacion => d }).size
    @path_proc = path_proc(@marcas.first)

  end

private
  def path_proc(marca)
    case marca.estado
      when 'sm' then lambda{ |m| edit_solicitud_marca_path(m) }
      when 'lp' then lambda{ |m| edit_lista_publicacion_path(m) }
    end
  end

end
