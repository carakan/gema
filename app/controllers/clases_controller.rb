# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ClasesController < ApplicationController
  #before_filter :revisar_permiso!
  # GET /clases
  # GET /clases.xml
  def index
    @clases = Clase.paginate(:page => @page)
    @titulo = "TG - Listado clases" 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clases }
      format.json  { render :json => @clases }
    end
  end

  # GET /clases/1
  # GET /clases/1.xml
  def show
    @clase = Clase.find(params[:id])
    @titulo = "Clase: #{@clase}" 

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clase }
    end
  end

  # GET /clases/new
  # GET /clases/new.xml
  def new
    @clase = Clase.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clase }
    end
  end

  # GET /clases/1/edit
  def edit
    @clase = Clase.find(params[:id])
  end

  # POST /clases
  # POST /clases.xml
  def create
    @clase = Clase.new(params[:clase])

    respond_to do |format|
      if @clase.save
        format.html { redirect_to(@clase, :notice => 'Clase creada con éxito') }
        format.xml  { render :xml => @clase, :status => :created, :location => @clase }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @clase.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clases/1
  # PUT /clases/1.xml
  def update
    @clase = Clase.find(params[:id])

    respond_to do |format|
      if @clase.update_attributes(params[:clase])
        format.html { redirect_to(@clase, :notice => 'Datos de la Clase actualizados con éxito') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @clase.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clases/1
  # DELETE /clases/1.xml
  def destroy
    @clase = Clase.find(params[:id])
    @clase.destroy

    respond_to do |format|
      format.html { redirect_to(clases_url) }
      format.xml  { head :ok }
    end
  end
end
