class SolicitudMarcasController < ApplicationController

  before_filter :authenticate_user!

  def new

  end

  def create
    @marca = SolicitudMarca.new(params[:solicitud_marca])

    respond_to do |format|
      if @marca.save
        format.html { redirect_ajax(@marca, 'La marca fue exitosamente creada.') }
        format.xml  { render :xml => @marca, :status => :created, :location => @marca }
      else
        format.html { render :action => "new", :status => :unprocessable_entity  }
        format.xml  { render :xml => @marca.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @marca = SolicitudMarca.find(params[:id])
    @marca.valid?
  end

  def update
    @marca = SolicitudMarca.find(params[:id])
    respond_to do |format|
      if @marca.update_attributes(params[:solicitud_marca])
        format.html { redirect_ajax(@marca, 'La marca fue exitosamente actualizada.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :status => :unprocessable_entity  }
        format.xml  { render :xml => @marca.errors, :status => :unprocessable_entity }
        format.json { render :json => @marca.hashify_errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @marca = SolicitudMarca.find(params[:id])
  end

  def destroy
    @marca = Marca.find(params[:id])
    @marca.destroy

    respond_to do |format|
      format.html { redirect_to(solicitud_marcas_url) }
      format.xml  { head :ok }
    end
  end
end
