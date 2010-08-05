class BusquedasController < ApplicationController
  def index
    @busqueda = []
    if params[:busqueda]
      @busqueda = Busqueda.realizar_busqueda(params)
    end

    @busq = BusquedaVacia.new
  end


  def new
    @params = params[:marcas]
    @busqueda = params[:busqueda]
  end
end
