class SolicitudMarcasController < ApplicationController

  def new

  end

  def create

  end

  def edit
    @marca = SolicitudMarca.find(params[:id])
    @marca.valid?
  end

  def udpate

  end
end
