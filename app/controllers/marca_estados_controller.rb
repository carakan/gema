class MarcaEstadosController < ApplicationController
  # GET /marca_estados
  # GET /marca_estados.xml
  def index
    @marca_estadoses = MarcaEstado.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @marca_estadoses }
    end
  end

  # GET /marca_estados/1
  # GET /marca_estados/1.xml
  def show
    @marca_estado = MarcaEstado.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @marca_estado }
    end
  end

  # GET /marca_estados/new
  # GET /marca_estados/new.xml
  def new
    @marca_estado = MarcaEstado.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @marca_estado }
    end
  end

  # GET /marca_estados/1/edit
  def edit
    @marca_estado = MarcaEstado.find(params[:id])
  end

  # POST /marca_estados
  # POST /marca_estados.xml
  def create
    @marca_estado = MarcaEstado.new(params[:marca_estado])

    respond_to do |format|
      if @marca_estado.save
        format.html { redirect_to(@marca_estado, :notice => 'Marca estado was successfully created.') }
        format.xml  { render :xml => @marca_estado, :status => :created, :location => @marca_estado }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @marca_estado.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /marca_estados/1
  # PUT /marca_estados/1.xml
  def update
    @marca_estado = MarcaEstado.find(params[:id])

    respond_to do |format|
      if @marca_estado.update_attributes(params[:marca_estado])
        format.html { redirect_to(@marca_estado, :notice => 'Marca estado was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @marca_estado.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /marca_estados/1
  # DELETE /marca_estados/1.xml
  def destroy
    @marca_estado = MarcaEstado.find(params[:id])
    @marca_estado.destroy

    respond_to do |format|
      format.html { redirect_to(marca_estadoses_url) }
      format.xml  { head :ok }
    end
  end
end
