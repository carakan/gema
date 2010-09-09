# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ReporteMarcasController < ApplicationController
  # GET /reporte_marcas
  # GET /reporte_marcas.xml
  def index
    params[:tipo] ||= :agentes
    @representantes = Consulta.representantes(params[:importacion_id], params[:tipo])
    @importacion = Importacion.find(params[:importacion_id])
    tipo = params[:tipo].to_s.singularize.capitalize
    @reportes = ReporteMarca.all(:conditions => 
      {:importacion_id => params[:importacion_id], :representante_type => tipo } 
    )

    if request.xhr?
      render :partial => 'representantes'
    else
      render :action => 'index'
    end
  end

  # GET /reporte_marcas/1
  # GET /reporte_marcas/1.xml
  def show
    @reporte_marca = ReporteMarca.find(params[:id])
    @importacion = Importacion.find(@reporte_marca.importacion_id) unless @reporte_marca.importacion_id.nil?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reporte_marca }
    end
  end

  # GET /reporte_marcas/new
  def new
    @reporte_marca = ReporteMarca.nuevo_busqueda(:idioma => 'es', :consulta_ids => params[:consulta_ids])
    params[:marca_ids].each{ |k,v| @reporte_marca.reporte_marca_detalles.build(:marca_id => v) }
  end

  # GET /reporte_marca/1/dowload
  # Metodo para descargar el reporte en PDF
  def download
    @reporte_marca = ReporteMarca.find(params[:id])
    rep = CruceReport.new
    send_data rep.to_pdf(@reporte_marca), :filename => "#{@reporte_marca.crear_nombre_archivo}.pdf"
  end

  # GET /reporte_marcas/new
  # GET /reporte_marcas/new.xml
  def cruce
    preparar_datos_cruce
    @reporte_marca = ReporteMarca.new(:representante_id => params[:representante_id], 
                                      :representante_type => params[:representante_type],
                                      :importacion_id => params[:importacion_id], :idioma => 'es')
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reporte_marca }
    end
  end

  # GET /reporte_marcas/1/edit
  def edit
    @reporte_marca = ReporteMarca.find(params[:id])
    [:representante_type, :representante_id, :importacion_id].each do |param|
      params[param] = @reporte_marca.send(param)
    end
    preparar_datos_cruce
  end

  # POST /reporte_marcas
  # POST /reporte_marcas.xml
  def create
    @reporte_marca = ReporteMarca.new(params[:reporte_marca])

    if @reporte_marca.save
      redirect_to(@reporte_marca, :notice => 'Se ha salvado correctamente el reporte.')
    else
      preparar_datos_cruce if @reporte_marca.importacion_id? 
      render :action => "cruce"
    end
  end

  # PUT /reporte_marcas/1
  # PUT /reporte_marcas/1.xml
  def update
    @reporte_marca = ReporteMarca.find(params[:id])

    if @reporte_marca.update_attributes(params[:reporte_marca])
      redirect_to(@reporte_marca, :notice => 'Se ha salvado correctamente el reporte.')
    else
      preparar_datos_cruce
      render :action => "edit"
    end
  end

  # DELETE /reporte_marcas/1
  # DELETE /reporte_marcas/1.xml
  def destroy
    @reporte_marca = ReporteMarca.find(params[:id])
    @reporte_marca.destroy

    respond_to do |format|
      format.html { redirect_to(reporte_marcas_url) }
      format.xml  { head :ok }
    end
  end
private
  def preparar_datos_cruce
    p = params[:representante_id].nil? ? params[:reporte_marca] : params
    if 'Agente' == p[:representante_type]
      tipo = :agentes
    else
      tipo = :titulares
    end
    params[:representante_type] = p[:representante_type]
    
    @representante = Representante.find(p[:representante_id])
    @importacion = Importacion.find(p[:importacion_id])
    @marcas = Consulta.marcas_representante_cruce(p[:importacion_id], p[:representante_id], tipo )
  end
end
