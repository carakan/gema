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
        fecha_importacion = SolicitudMarca.importar( params[:marca][:archivo] )
        redirect_to(importado_solicitud_url( fecha_importacion ) )
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

  # Presenta la lista de importaciones
  def importaciones
    @marcas = Marca.paginate( :select => "DISTINCT(fecha_importacion) as fecha_importacion, estado_tipo", :order => "fecha_imp DESC", :page => @page )
  end

  # Presenta el listado de una importacion realizada
  def importado()
    @mostrar = 'error'

    conditions = { :fecha_importacion => params[:id] }
    @mostrar = params[:mostrar] unless params[:mostrar].nil?
    case @mostrar
      when 'all'
        @marcas = Marca.paginate( :conditions => conditions, :page => @page )
      when 'valid'
        @marcas = Marca.paginate( :conditions => conditions.merge( :valido => true ), :page => @page )
      else
        @marcas = Marca.all( :conditions => conditions.merge( :valido => false ), :page => @page )
    end

    @total = Marca.all( :conditions =>  { :fecha_importacion => params[:id] }).size

  end
end
