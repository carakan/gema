class Proyecto::InstruccionesController < ApplicationController
  def index
    @instrucciones = Proyecto::Instruccion.all
  end
  
  def show
    @instruccion = Proyecto::Instruccion.find(params[:id])
  end
  
  def new
    @instruccion = Proyecto::Instruccion.new
  end
  
  def create
    @instruccion = Proyecto::Instruccion.new(params[:proyecto_instruccion])
    if @instruccion.save
      flash[:notice] = "Successfully created proyecto/instruccion."
      redirect_to @instruccion
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
      flash[:notice] = "Successfully updated proyecto/instruccion."
      redirect_to @instruccion
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @instruccion = Proyecto::Instruccion.find(params[:id])
    @instruccion.destroy
    flash[:notice] = "Successfully destroyed proyecto/instruccion."
    redirect_to proyecto_instruccions_url
  end
end
