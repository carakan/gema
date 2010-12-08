# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ListasController < ApplicationController
  protect_from_forgery :except => :reporte
  def index
    params[:page]
    @marcas = Marca.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @importacion = Importacion.find(params[:id])
    @busqueda = @importacion.marcas
    @busqueda.sort! { |a, b| [a.agente_ids_serial.sort, a.titular_ids_serial.sort] <=> [b.agente_ids_serial.sort, b.titular_ids_serial.sort]  }
  end

  def reporte
    marca_ids = params[:marca_ids].split(",") 
    marcas = Marca.find(marca_ids)
    importacion = Importacion.find(params[:importacion])
    respond_to do |format|
      format.html do
        reporte = Reporte.crear_reporte() do
          report = Reporte.set_instance("lista_publicacion")
          report.engine_report.marcas = marcas
          report.engine_report.titulares = Marca.first(:conditions => {:id => marca_ids}).titulares.join(", ")
          report.engine_report.importacion = importacion
          report.to_pdf()
        end
        send_data reporte, :filename => "lista_publicacion.pdf"
      end
      format.xls do
        if @reporte_marca.importacion_id
          reporte = render_to_string(:partial => "tabla_cruce", :locals => {:show_titulares => true})
        else
          reporte = render_to_string(:partial => "tabla_busqueda", :locals => {:show_titulares => true})
        end
        send_data reporte, :filename => "#{nombre_archivo}.xls", :type => 'application/vnd.ms-excel; charset=utf-8'
      end
    end
  end
end
