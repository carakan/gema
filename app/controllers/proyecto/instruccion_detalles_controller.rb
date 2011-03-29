class Proyecto::InstruccionDetallesController < ApplicationController
  def index
    @instruccion_detalles = Proyecto::InstruccionDetalle.all
  end
  
  def show
    @instruccion_detalle = Proyecto::InstruccionDetalle.find(params[:id])
  end
  
  def new
    @instruccion_detalle = Proyecto::InstruccionDetalle.new
  end
  
  def create
    @instruccion_detalle = Proyecto::InstruccionDetalle.new(params[:proyecto_instruccion_detalle])
    if @instruccion_detalle.save
      flash[:notice] = "Successfully created proyecto/instruccion detalle."
      redirect_to @instruccion_detalle
    else
      render :action => 'new'
    end
  end
  
  def edit
    @instruccion_detalle = Proyecto::InstruccionDetalle.find(params[:id])
  end
  
  def update
    @instruccion_detalle = Proyecto::InstruccionDetalle.find(params[:id])
    if @proyecto/instruccion_detalle.update_attributes(params[:proyecto_instruccion_detalle])
      flash[:notice] = "Successfully updated proyecto/instruccion detalle."
      redirect_to @instruccion_detalle
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @instruccion_detalle = Proyecto::InstruccionDetalle.find(params[:id])
    @instruccion_detalle.destroy
    flash[:notice] = "Successfully destroyed proyecto/instruccion detalle."
    redirect_to proyecto/instruccion_detalles_url
  end
end
