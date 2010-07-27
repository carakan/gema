class ImportacionesController < ApplicationController
  # GET /importaciones
  # GET /importaciones.xml
  def index
    @marcas = Marca.view_importaciones( @page )
  end

  # GET /importaciones/1
  # GET /importaciones/1.xml
  def show
    @importacion = Importacion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @importacion }
    end
  end

  # GET /importaciones/new
  # GET /importaciones/new.xml
  def new
    @marca = ImportacionVacia.new(:tipo => params[:tipo])
  end

  # GET /importaciones/1/edit
  #def edit
  #  @importacion = Importacion.find(params[:id])
  #end

  # POST /importaciones
  # POST /importaciones.xml
  def create
    @marca = ImportacionVacia.new( params[:importacion_vacia] )
    if @marca.valid? == true
      importacion_id = Marca.importar(params[:importacion_vacia])
      redirect_to importacion_url( importacion_id ), :notice => "Se ha importado los datos"
    else
      render :action => 'new'
    end
  end

  
  # Presenta el listado de una importacion realizada
  def show
    @importacion = Importacion.find(params[:id])
    @marcas = Marca.importado( params[:id] ).paginate(:page => @page )
  end

  # PUT /importaciones/1
  # PUT /importaciones/1.xml
  #def update
  #  @importacion = Importacion.find(params[:id])

  #  respond_to do |format|
  #    if @importacion.update_attributes(params[:importacion])
  #      format.html { redirect_to(@importacion, :notice => 'Importacion was successfully updated.') }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @importacion.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /importaciones/1
  # DELETE /importaciones/1.xml
  #def destroy
  #  @importacion = Importacion.find(params[:id])
  #  @importacion.destroy

  #  respond_to do |format|
  #    format.html { redirect_to(importaciones_url) }
  #    format.xml  { head :ok }
  #  end
  #end
end
