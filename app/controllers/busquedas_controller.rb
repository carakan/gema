class BusquedasController < ApplicationController
  def index
    @busqueda = []
    if params[:busqueda]
      @exp = Busqueda.realizar_busqueda(params)
      @busqueda = []
    end

    @busq = BusquedaVacia.new
  end
end
