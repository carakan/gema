# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ConsultasController < ApplicationController
  before_filter :authenticate_usuario!

  before_filter :set_busqueda, :only => [:new, :create]

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

  # POST /consultas/cruce
  def cruce
    @consulta = Consulta.new(params[:consulta])

    if params[:commit] == "Pre reporte"
      @consulta = Consulta.new(params[:consulta])

      if @consulta.save
        redirect_to "/busquedas/cruce/?reporte=true&consulta_id=#{@consulta.id}&importacion_id=#{@consulta.importacion_id}&marca_id=#{@consulta.marca_id}page=#{@page}", :notice => "Se ha almacenado el cruce"
      end
    else
      Consulta.descartar( params[:consulta] )
      redirect_to cruce_importaciones_url(:importacion_id => @consulta[:importacion_id], :page => @page), :notice => "Se ha descartado el cruce"
    end
    #importacion_id=1&marca_id=36&page=1&consulta_id=6
  end

  # POST /consultas
  # POST /consultas.xml
  def create
    @consulta = Consulta.new(params[:consulta])
    
    if @consulta.save
      unless @consulta.importacion.nil?
        notice = "Se ha almacenado la consulta del cruce"
        uri = cruce_importaciones_url(:importacion_id => @consulta.importacion.id, :page => @page)
      else
        notice = "Se ha almacenado la consulta"
        uri = new_reporte_marca_url(:consulta_id => @consulta.id)
      end
      if params[:avanzado]
        uri = download_advanced_reporte_marca_path(:id => @consulta.id)
      end
      redirect_to uri, :notice => notice
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
  def destroy
    @consulta = Consulta.find(params[:id])
    @consulta.destroy

    respond_to do |format|
      format.html { redirect_to(consultas_url) }
      format.xml  { head :ok }
    end
  end

  private
  def set_busqueda
    if params[:busqueda]
      @busqueda = params[:busqueda]
    elsif
      @busqueda = params[:consulta][:busqueda]
    end
  end

  def descartar_cruce
    Consulta.descartar( params )
    redirect_to cruce_importaciones_url(:importacion_id => params[:importacion_id], :page => @page), :notice => "Se ha descartado el cruce"
    return
  end


end
