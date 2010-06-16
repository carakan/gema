class SolicitudMarcasController < ApplicationController

  def new

  end

  def create
    @marca = SolicitudMarca.new(params[:marca])

    respond_to do |format|
      if @marca.save
        format.html { redirect_to(@marca, :notice => 'La marca fue exitosamente creada.') }
        format.xml  { render :xml => @marca, :status => :created, :location => @marca }
      else
        format.html { render :action => "new" }
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
      if @marca.update_attributes(params[:marca])
        format.html { redirect_to(@marca, :notice => 'La marca fue exitosamente actualizada.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @marca.errors, :status => :unprocessable_entity }
        format.json { render :json => @marca.hashify_errors, :status => :unprocessable_entity }
      end
    end
  end
end
