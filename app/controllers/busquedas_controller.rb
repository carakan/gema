class BusquedasController < ApplicationController
  def index
    @busqueda = []
    if params[:busqueda]
      @busqueda = Busqueda.realizar_busqueda(params)
    end

    @busq = BusquedaVacia.new
  end

  def cruce
    #Consulta.find(params[:consulta_id]).destroy unless params[:consulta_id].nil?

    @marca = Marca.find(params[:marca_id])
    query = { :busqueda => @marca.nombre, :clases => (1..45).to_a.join(","), :propia => true }
    @importacion = Importacion.find(params[:importacion_id])
    @consulta = Consulta.find(params[:consulta_id]) unless params[:consulta_id].nil?

    @busqueda = Busqueda.realizar_busqueda(query)
    @busq = BusquedaVacia.new
  end

  def verificar_cruce
    @marca = Marca.find(params[:marca_id])
    query = { :busqueda => @marca.nombre, :clases => (1..45).to_a.join(","), :propia => true }
    @importacion = Importacion.find(params[:importacion_id])

    @busqueda = Busqueda.realizar_busqueda(query)
    @busq = BusquedaVacia.new
  end

end
