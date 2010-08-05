class BusquedasController < ApplicationController
  def index
    @busqueda = []
    if params[:busqueda]
      @busqueda = Busqueda.realizar_busqueda(params)
    end

    @busq = BusquedaVacia.new
  end

  def cruce
    @marca = Marca.find(params[:marca_id])
    query = { :busqueda => @marca.nombre, :clases => (1..45).to_a.join(",") }
    @importacion = Importacion.find(params[:importacion_id])

    @busqueda = Busqueda.realizar_busqueda(query)

    @busq = BusquedaVacia.new
  end

end
