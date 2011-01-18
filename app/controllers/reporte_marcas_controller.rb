# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ReporteMarcasController < ApplicationController
  protect_from_forgery :except => :cruce
  # GET /reporte_marcas
  def index
    @reporte_marcas = ReporteMarca.paginate(:include => :representante, :page => @page, :order => "updated_at DESC")
  end

  # GET /reporte_marcas/cruce
  # GET /reporte_marcas.xml
  def cruces
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
      render :action => 'cruces'
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
    @consulta = Consulta.find(params[:consulta_id])
    @reporte_marca = ReporteMarca.nuevo_busqueda(:idioma => 'es', :consulta_id => params[:consulta_id], :representante_id => @consulta.representante_id)
  end

  # GET /reporte_marca/1/dowload
  # Metodo para descargar el reporte en PDF
  def download
    @reporte_marca = ReporteMarca.find(params[:id])
    if @reporte_marca
      nombre_archivo = @reporte_marca.crear_nombre_archivo
      respond_to do |format|
        format.html do
          reporte = Reporte.crear_reporte(@reporte_marca)
          send_data reporte, :filename => "#{nombre_archivo}.pdf"
        end
        format.xls do
          if @reporte_marca.importacion_id
            reporte = render_to_string(:partial => "tabla_cruce", :locals => {:show_titulares => true})
          else
            reporte = render_to_string(:partial => "tabla_busqueda", :locals => {:show_titulares => true})
          end
          send_data reporte.encode('ISO-8859-1'), :filename => "#{nombre_archivo}.xls", :type => 'application/vnd.ms-excel;', :encoding => 'utf-8'
        end
      end
    else
      raise "Error el reporte que solicito no existe"
    end
  end

  def download_advanced
    consulta = Consulta.find(params[:id])
    reporte = render_to_string(:partial => "tabla_busqueda_avanzada_long", :locals => {:show_titulares => true, :consulta => consulta})
    send_data reporte.encode('ISO-8859-1'), :filename => "busqueda_avanzada.xls", :type => 'application/vnd.ms-excel;', :encoding => 'utf-8'
  end

  # GET /reporte_marcas/new
  # GET /reporte_marcas/new.xml
  def cruce
    @importacion = Importacion.find(params[:importacion_id])
    if @importacion.tipo == "lp"
      tipo = ReporteMarca::TIPO["Cruce"]
    elsif
      tipo = ReporteMarca::TIPO["Solicitud Marca"]
    end
    @reporte_marca = ReporteMarca.new(:importacion_id => @importacion.id, :idioma => params[:language], :tipo_reporte => tipo, :carta => params[:observaciones])
    preparar_datos_cruce
    @reporte_marca.save!
    respond_to do |format|
      format.html { redirect_to download_reporte_marca_url(@reporte_marca) }
      format.xml  { render :xml => @reporte_marca }
      format.xls { redirect_to download_reporte_marca_url(@reporte_marca, :format => "xls") }
    end
  end

  # GET /reporte_marcas/1/edit
  def edit
    @reporte_marca = ReporteMarca.find(params[:id])
    preparar_datos_cruce
  end

  # POST /reporte_marcas
  # POST /reporte_marcas.xml
  def create
    @reporte_marca = ReporteMarca.new(params[:reporte_marca])
    preparar_datos_cruce


    if @reporte_marca.save
      redirect_to(@reporte_marca, :notice => 'Se ha salvado correctamente el reporte.')
      flash[:notice] = "Se guardo el reporte"
    else
      flash[:notice] = "No se pudo guardar los datos"
      action = preparar_datos
      render :action => action
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
  # Prepara los datos para cuando se realiza un reporte de cruce o 
  # un reporte de busquedas
  # @
  def preparar_datos
    if @reporte_marca.importacion_id?
      preparar_datos_cruce
      'cruce'
    else
      'new'
    end
  end

  # Prepara los datos para un cruce
  def preparar_datos_cruce
    if !@reporte_marca.new_record?
      if !@reporte_marca.importacion_id.nil?
        @importacion = @reporte_marca.importacion
        @reporte_marca.tipo_reporte = ReporteMarca::TIPO["Cruce"]
      else
        @reporte_marca.tipo_reporte = ReporteMarca::TIPO["Busqueda"]
      end
    end
    @marca_ids = params[:marca_ids].split(",").collect{|id| id.to_i} if params[:marca_ids]
    @importacion = Importacion.find(params[:importacion_id] ) if params[:importacion_id]
    @marcas = Marca.all(:conditions => {:id => @marca_ids})
    @marca = Marca.find(params[:marca_foranea]) if params[:marca_foranea]

    if @marca && @marca_ids
      @reporte_marca.marca_ids_serial = @marca_ids
      @reporte_marca.marca_foranea_id = @marca.id
    end

    result = []

    @marcas.each {|marca|  result << {
        :marca_id => marca.id, :comentario => params["observaciones_#{marca.id}"]
      }}
    @reporte_marca.reporte_marca_detalles_attributes = result
  end
end