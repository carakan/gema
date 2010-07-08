class MarcasController < ApplicationController

  def index
    @marcas = Marca.buscar(:page => @page, :params => params)
  end

  def new
    @marca = Marca.new(:estado_fecha => Date.today, :agente_ids => [1, 2])
  end

  def edit
    @marca = Marca.find(params[:id])
  end


  def create
    @marca = Marca.crear_instancia(params)
    
    if @marca.save
      redirect_to @marca, :notice => 'Se ha salvado correctamente'
    else
      render :action => 'new'
    end
  end

  def update
    @marca = Marca.find(params[:id])
    if @marca.update_marca(params)
      redirect_to marca_url(@marca.id)
    else
      render :action => 'edit'
    end
  end

  def show
    @marca = Marca.find(params[:id])
  end

end
