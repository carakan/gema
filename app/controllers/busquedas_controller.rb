# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class BusquedasController < ApplicationController
  #before_filter :authenticate_usuario!

  # GET /busquedas
  def index
    @busqueda = []
    params[:tipo_busqueda] = 'prev' if params[:tipo_busqueda].nil?
    if params[:busqueda]
      @busqueda = Busqueda.realizar_busqueda(params)
      @busqueda2 = Busqueda.realizar_busqueda({:busqueda => params[:busqueda], :tipo_representante => 1}, Representante)
      @representantes = Busqueda.preparar_representantes(@busqueda)
      # Crea una nueva busqueda con los parametros de la busqueda
      @consulta = Consulta.nueva(params)
    end

    @busq = BusquedaVacia.new
  end

  # GET /busquedas/cruce
  def cruce
    @marca = Marca.find(params[:marca_id])
    query = { :busqueda => @marca.nombre, :clases => (1..45).to_a.join(","), 
      :propia => true, :id => @marca.id, :clase_id => @marca.clase_id, :tipo => :cruce }
    @importacion = Importacion.find(params[:importacion_id])

    @busqueda = Busqueda.realizar_busqueda(query)

    @busqueda.sort! { |a, b| [a.agente_ids_serial.sort, a.titular_ids_serial.sort] <=> [b.agente_ids_serial.sort, b.titular_ids_serial.sort]  }

    query[:clases] = (1..45).to_a
    @con = Consulta.new(:consulta_id => params[:consulta_id], :busqueda => @marca.nombre, :parametros => query, 
      :importacion_id => params[:importacion_id], :marca_id => params[:marca_id])
    @consulta_detalles = []
    unless params[:consulta_id].nil?
      @consulta = Consulta.find(params[:consulta_id]) 
      @consulta_detalles = @consulta.consulta_detalles.map(&:marca_id)
      @con.comentario = @consulta.comentario
    end

    @representantes = Busqueda.preparar_representantes(@busqueda)
    #@busq = BusquedaVacia.new
  end

  def verificar_cruce
    @marca = Marca.find(params[:marca_id])
    query = { :busqueda => @marca.nombre, :clases => (1..45).to_a.join(","), :propia => true }
    @importacion = Importacion.find(params[:importacion_id])

    @busqueda = Busqueda.realizar_busqueda(query)
    @busq = BusquedaVacia.new
  end

  def busqueda_avanzada
    if params[:search]
      params = prepare_search
      @busqueda = Marca.search(params[:search])
      @representantes = Busqueda.preparar_representantes(@busqueda)
    end
    
    @consulta = Consulta.new()
  end

  private

  def splits_params(params, name, new_name)
    values = params.delete(name).split(" ")
    return params[new_name] = values
  end

  def prepare_search
    if params[:clases] && !params[:clases].empty?
      params[:search][:clase_id_in] = params[:clases].keys
    end
    params
  end
end
