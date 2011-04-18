# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class AdjuntosController < ApplicationController
  before_filter :set_proyecto
  # GET /adjuntos
  # GET /adjuntos.xml
  def index
    @adjuntos = Adjunto.paginate(:per_page => 20, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @adjuntos }
    end
  end

  # GET /adjuntos/1
  # GET /adjuntos/1.xml
  def show
    @adjunto = Adjunto.find(params[:id])
    send_file @adjunto.archivo.path, :filename => @adjunto.archivo.original_filename
  end

  # GET /adjuntos/new
  # GET /adjuntos/new.xml
  def new
    @adjunto = Adjunto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @adjunto }
    end
  end

  # GET /adjuntos/1/edit
  def edit
    @adjunto = Adjunto.find(params[:id])
  end

  # POST /adjuntos
  # POST /adjuntos.xml
  def create
    
    if @proyecto
      value = proyecto_proyecto_path(@proyecto)
      @adjunto = @proyecto.adjuntos.new(params[:adjunto])
    else
      value = @adjunto
      @adjunto = Adjunto.new(params[:adjunto])
    end
    respond_to do |format|
      if @adjunto.save
        format.html { redirect_to(value, :notice => 'Adjunto was successfully created.') }
        format.xml  { render :xml => @adjunto, :status => :created, :location => @adjunto }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @adjunto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /adjuntos/1
  # PUT /adjuntos/1.xml
  def update
    @adjunto = Adjunto.find(params[:id])

    respond_to do |format|
      if @adjunto.update_attributes(params[:adjunto])
        format.html { redirect_to(@adjunto, :notice => 'Adjunto was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @adjunto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /adjuntos/1
  # DELETE /adjuntos/1.xml
  def destroy
    @adjunto = Adjunto.find(params[:id])
    @adjunto.destroy

    respond_to do |format|
      format.html { redirect_to(adjuntos_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def set_proyecto
    @proyecto = Proyecto::Proyecto.find(params[:proyecto_id])
  rescue
  end
end
