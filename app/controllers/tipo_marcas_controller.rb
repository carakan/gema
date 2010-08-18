class TipoMarcasController < ApplicationController
  before_filter :revisar_permiso!
  # GET /tipo_marcas
  # GET /tipo_marcas.xml
  def index
    @tipo_marcas = TipoMarca.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tipo_marcas }
    end
  end

  # GET /tipo_marcas/1
  # GET /tipo_marcas/1.xml
  def show
    @tipo_marca = TipoMarca.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tipo_marca }
    end
  end

  # GET /tipo_marcas/new
  # GET /tipo_marcas/new.xml
  def new
    @tipo_marca = TipoMarca.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tipo_marca }
    end
  end

  # GET /tipo_marcas/1/edit
  def edit
    @tipo_marca = TipoMarca.find(params[:id])
  end

  # POST /tipo_marcas
  # POST /tipo_marcas.xml
  def create
    @tipo_marca = TipoMarca.new(params[:tipo_marca])

    respond_to do |format|
      if @tipo_marca.save
        format.html { redirect_to(@tipo_marca, :notice => 'El tipo de marca fue creado con exito.') }
        format.xml  { render :xml => @tipo_marca, :status => :created, :location => @tipo_marca }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tipo_marca.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tipo_marcas/1
  # PUT /tipo_marcas/1.xml
  def update
    @tipo_marca = TipoMarca.find(params[:id])

    respond_to do |format|
      if @tipo_marca.update_attributes(params[:tipo_marca])
        format.html { redirect_to(@tipo_marca, :notice => 'Los datos del tipo de marca fueron actualizados de manera correcta.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tipo_marca.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_marcas/1
  # DELETE /tipo_marcas/1.xml
  def destroy
    @tipo_marca = TipoMarca.find(params[:id])
    @tipo_marca.destroy

    respond_to do |format|
      format.html { redirect_to(tipo_marcas_url) }
      format.xml  { head :ok }
    end
  end
end
