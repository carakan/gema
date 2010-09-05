class ReporteMarcasController < ApplicationController
  # GET /reporte_marcas
  # GET /reporte_marcas.xml
  def index
    params[:tipo] ||= :agentes
    @representantes = Consulta.representantes(params[:importacion_id], params[:tipo])
    @importacion = Importacion.find(params[:importacion_id])

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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reporte_marca }
    end
  end

  # GET /reporte_marcas/new
  # GET /reporte_marcas/new.xml
  def cruce
    preparar_datos_cruce
    @reporte_marca = ReporteMarca.new(:representante_id => params[:representante_id], 
                                      :representante_type => params[:representante_type],
                                      :importacion_id => params[:importacion_id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reporte_marca }
    end
  end

  # GET /reporte_marcas/1/edit
  def edit
    @reporte_marca = ReporteMarca.find(params[:id])
  end

  # POST /reporte_marcas
  # POST /reporte_marcas.xml
  def create
    @reporte_marca = ReporteMarca.new(params[:reporte_marca])

    if @reporte_marca.save
      redirect_to(@reporte_marca, :notice => 'ReporteMarca was successfully created.')
    else
      preparar_datos_cruce
      render :action => "cruce"
    end
  end

  # PUT /reporte_marcas/1
  # PUT /reporte_marcas/1.xml
  def update
    @reporte_marca = ReporteMarca.find(params[:id])

    respond_to do |format|
      if @reporte_marca.update_attributes(params[:reporte_marca])
        format.html { redirect_to(@reporte_marca, :notice => 'ReporteMarca was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reporte_marca.errors, :status => :unprocessable_entity }
      end
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
    
    @representante = Representante.find(p[:representante_id])
    @importacion = Importacion.find(p[:importacion_id])
    @marcas = Consulta.marcas_representante_cruce(p[:importacion_id], p[:representante_id], tipo )
  end
end
