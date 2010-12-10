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
    @busqueda = @importacion.marcas.propias
    @busqueda.sort! { |a, b| [a.agente_ids_serial.sort, a.titular_ids_serial.sort] <=> [b.agente_ids_serial.sort, b.titular_ids_serial.sort]  }
  end

  def reporte
    marca_ids = params[:marca_ids].split(",") 
    marcas = Marca.find(marca_ids)
    importacion = Importacion.find(params[:importacion])

    reporte_marca = ReporteMarca.create(:idioma => params[:lang], :marca_ids_serial => marca_ids, :tipo_reporte => ReporteMarca::TIPO["Lista Publicacion"], :importacion_id => importacion.id)
    
    redirect_to download_reporte_marca_url(reporte_marca)
  end
end
