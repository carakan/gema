class Proyecto::InstruccionDetallesController < ApplicationController
  before_filter :set_instruccion
  def index
    @instruccion_detalles = @instruccion.instruccion_detalles.all
  end
  
  def show
    @instruccion_detalle = @instruccion.instruccion_detalles.find(params[:id])
  end
  
  def new
    @instruccion_detalle = @instruccion.instruccion_detalles.new
  end
  
  def create
    @instruccion_detalle = @instruccion.instruccion_detalles.new(params[:proyecto_instruccion_detalle])
    if @instruccion_detalle.save
      redirect_to proyecto_proyecto_url(@proyecto), :notice => "Ha sido satisfactoriamente creada la Tarea."
    else
      render :action => 'new'
    end
  end
  
  def edit
    @instruccion_detalle = Proyecto::InstruccionDetalle.find(params[:id])
  end
  
  def update
    @instruccion_detalle = Proyecto::InstruccionDetalle.find(params[:id])
    if @instruccion_detalle.update_attributes(params[:proyecto_instruccion_detalle])
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
    
  end

  protected
  def set_instruccion
    @proyecto = Proyecto::Proyecto.find(params[:proyecto_id])
    @instruccion = @proyecto.instruccions.find(params[:instruccion_id])
  end
end