class ConsultasController < ApplicationController
  before_filter :set_busqueda, :only => [:new, :create]
  before_filter :borrar_consulta, :only => [:new]  
  # GET /consultas
  # GET /consultas.xml
  def index
    @consultas = Consulta.paginate( :page => @oage, 
                    :conditions => { :importacion_id => 0 }, 
                    :include => [ :consulta_detalles, :usuario],
                    :order => "consultas.created_at DESC" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultas }
    end
  end

  # GET /consultas/1
  # GET /consultas/1.xml
  def show
    @consulta = Consulta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consulta }
    end
  end

  # GET /consultas/new
  # GET /consultas/new.xml
  def new
    if params[:commit] == 'Descartar'
      Consulta.descartar( params )
      redirect_to cruce_importacion_url(params[:importacion_id], :page => @page), :notice => "Se ha descartado el cruce"
      return
    end

    @consulta = Consulta.nueva(params)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consulta }
    end
  end

  # GET /consultas/1/edit
  #def edit
  #  @consulta = Consulta.find(params[:id])
  #end

  # POST /consultas
  # POST /consultas.xml
  def create
    @consulta = Consulta.new(params[:consulta])

    unless @consulta.importacion.nil?
      notice = "Se ha realizado el informe del cruce"
      path = cruce_importacion_url(@consulta.importacion, :page => @page)
    else
      notice = "Se ha realizado el informe de la consulta"
      path = @consulta
    end

    if @consulta.save
      redirect_to path, :notice => notice
    else
      render :action => "new"
    end
  end

  # PUT /consultas/1
  # PUT /consultas/1.xml
  #def update
  #  @consulta = Consulta.find(params[:id])

  #  respond_to do |format|
  #    if @consulta.update_attributes(params[:consulta])
  #      format.html { redirect_to(@consulta, :notice => 'Consulta was successfully updated.') }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @consulta.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  ## DELETE /consultas/1
  ## DELETE /consultas/1.xml
  #def destroy
  #  @consulta = Consulta.find(params[:id])
  #  @consulta.destroy

  #  respond_to do |format|
  #    format.html { redirect_to(consultas_url) }
  #    format.xml  { head :ok }
  #  end
  #end

private
  def set_busqueda
    if params[:busqueda]
      @busqueda = params[:busqueda]
    elsif
      @busqueda = params[:consulta][:busqueda]
    end
  end

  # Borra una consulta previamente realizada
  def borrar_consulta
    Consulta.find(params[:consulta_id]).destroy unless params[:consulta_id].nil?
  end
end
