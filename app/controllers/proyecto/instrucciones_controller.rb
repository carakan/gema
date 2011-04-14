class Proyecto::InstruccionesController < ApplicationController
  before_filter :set_proyecto
  
  def index
    @instrucciones = Proyecto::Instruccion.find(:all)
  end
  
  def show
    @instruccion = Proyecto::Instruccion.find(params[:id])
  end
  
  def new
    @instruccion = Proyecto::Instruccion.new
    @instruccion.instruccion_detalles << @instruccion.instruccion_detalles.build
  end
  
  def create
    @instruccion = @proyecto.instruccions.new(params[:proyecto_instruccion])
    if @instruccion.save
      redirect_to proyecto_proyecto_url(@proyecto), :notice => "Ha sido creado con exito esta instruccion"
    else
      render :action => 'new'
    end
  end
  
  def edit
    @instruccion = Proyecto::Instruccion.find(params[:id])
  end
  
  def update
    @instruccion = Proyecto::Instruccion.find(params[:id])
    if @instruccion.update_attributes(params[:proyecto_instruccion])
      redirect_to proyecto_proyecto_instrucciones_url(@proyecto), :notice => "Instruccion Actualizada"
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @instruccion = Proyecto::Instruccion.find(params[:id])
    @instruccion.destroy
    redirect_to proyecto_proyecto_instrucciones_url, :notice => "Ha sido destruida la instruccion"
  end
  
  protected
  def set_proyecto
    @proyecto = Proyecto::Proyecto.find(params[:proyecto_id])
  end
end
