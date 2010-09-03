class ReporteMarcasController < ApplicationController
  # GET /reporte_marcas
  # GET /reporte_marcas.xml
  def index
    @reporte_marcas = ReporteMarca.all(:conditions => ["importacion_id = ?", params[:importacion_id] ] )
    @importacion = Importacion.find(params[:importacion_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reporte_marcas }
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
  def new
    @reporte_marca = ReporteMarca.new

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

    respond_to do |format|
      if @reporte_marca.save
        format.html { redirect_to(@reporte_marca, :notice => 'ReporteMarca was successfully created.') }
        format.xml  { render :xml => @reporte_marca, :status => :created, :location => @reporte_marca }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reporte_marca.errors, :status => :unprocessable_entity }
      end
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
end
