class Proyecto::InstruccionDetallesController < ApplicationController
  def index
    @proyecto/instruccion_detalles = Proyecto::InstruccionDetalle.all
  end
  
  def show
    @proyecto/instruccion_detalle = Proyecto::InstruccionDetalle.find(params[:id])
  end
  
  def new
    @proyecto/instruccion_detalle = Proyecto::InstruccionDetalle.new
  end
  
  def create
    @proyecto/instruccion_detalle = Proyecto::InstruccionDetalle.new(params[:proyecto/instruccion_detalle])
    if @proyecto/instruccion_detalle.save
      flash[:notice] = "Successfully created proyecto/instruccion detalle."
      redirect_to @proyecto/instruccion_detalle
    else
      render :action => 'new'
    end
  end
  
  def edit
    @proyecto/instruccion_detalle = Proyecto::InstruccionDetalle.find(params[:id])
  end
  
  def update
    @proyecto/instruccion_detalle = Proyecto::InstruccionDetalle.find(params[:id])
    if @proyecto/instruccion_detalle.update_attributes(params[:proyecto/instruccion_detalle])
      flash[:notice] = "Successfully updated proyecto/instruccion detalle."
      redirect_to @proyecto/instruccion_detalle
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @proyecto/instruccion_detalle = Proyecto::InstruccionDetalle.find(params[:id])
    @proyecto/instruccion_detalle.destroy
    flash[:notice] = "Successfully destroyed proyecto/instruccion detalle."
    redirect_to proyecto/instruccion_detalles_url
  end
end
