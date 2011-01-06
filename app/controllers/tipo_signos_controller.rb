# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class TipoSignosController < ApplicationController
  before_filter :revisar_permiso!
  # GET /tipo_marcas
  # GET /tipo_marcas.xml
  def index
    @tipo_signos = TipoSigno.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tipo_signos }
    end
  end

  # GET /tipo_marcas/1
  # GET /tipo_marcas/1.xml
  def show
    @tipo_signos = TipoSigno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tipo_signos }
    end
  end

  # GET /tipo_marcas/new
  # GET /tipo_marcas/new.xml
  def new
    @tipo_signos = TipoSigno.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tipo_signos }
    end
  end

  # GET /tipo_marcas/1/edit
  def edit
    @tipo_signos = TipoSigno.find(params[:id])
  end

  # POST /tipo_marcas
  # POST /tipo_marcas.xml
  def create
    @tipo_signos = TipoSigno.new(params[:tipo_signo])
    
    respond_to do |format|
      if @tipo_signos.save
        format.html { redirect_to(@tipo_signos, :notice => 'El tipo de signo fue creado de forma correcta.') }
        format.xml  { render :xml => @tipo_signos, :status => :created, :location => @tipo_signos }
      else
    @tipo_signos.errors.add(:base, "Error crucial")
        format.html { render :action => "new" }
        format.xml  { render :xml => @tipo_signos.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tipo_marcas/1
  # PUT /tipo_marcas/1.xml
  def update
    @tipo_signos = TipoSigno.find(params[:id])

    respond_to do |format|
      if @tipo_signos.update_attributes(params[:tipo_signo])
        format.html { redirect_to(@tipo_signos, :notice => 'Los datos del tipo de signo fueron actualizados de forma correcta.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tipo_signos.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_marcas/tipo_signos
  # DELETE /tipo_marcas/1.xml
  def destroy
    @tipo_signos = TipoSigno.find(params[:id])
    @tipo_signos.destroy

    respond_to do |format|
      format.html { redirect_to(tipo_signos_url) }
      format.xml  { head :ok }
    end
  end
end
