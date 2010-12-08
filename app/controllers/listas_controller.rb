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
    respond_to do |format|
      format.html do
        reporte = Reporte.crear_reporte(@reporte_marca) do
          report = Reporte.set_instance("cruce_report")
          report.engine_report.marcas = [reporte_marca.marca_foranea]
          report.engine_report.titulares = Marca.first(:conditions => {:id => reporte_marca.marca_ids_serial}).titulares.join(", ")
          report.engine_report.importacion = reporte_marca.importacion
        end
        send_data reporte, :filename => "#{nombre_archivo}.pdf"
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
