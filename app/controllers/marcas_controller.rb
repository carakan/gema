class MarcasController < ApplicationController

  def index
    @marcas = Marca.paginate(:page => @page, :include => [:agente, :titular])
  end

  def edit
    @marca = Marca.find(params[:id])
  end

  def new
    @marca = Marca.new
  end


end
