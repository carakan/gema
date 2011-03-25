class Proyecto::InstruccionsController < ApplicationController
  def index
    @proyecto/instruccions = Proyecto::Instruccion.all
  end
  
  def show
    @proyecto/instruccion = Proyecto::Instruccion.find(params[:id])
  end
  
  def new
    @proyecto/instruccion = Proyecto::Instruccion.new
  end
  
  def create
    @proyecto/instruccion = Proyecto::Instruccion.new(params[:proyecto/instruccion])
    if @proyecto/instruccion.save
      flash[:notice] = "Successfully created proyecto/instruccion."
      redirect_to @proyecto/instruccion
    else
      render :action => 'new'
    end
  end
  
  def edit
    @proyecto/instruccion = Proyecto::Instruccion.find(params[:id])
  end
  
  def update
    @proyecto/instruccion = Proyecto::Instruccion.find(params[:id])
    if @proyecto/instruccion.update_attributes(params[:proyecto/instruccion])
      flash[:notice] = "Successfully updated proyecto/instruccion."
      redirect_to @proyecto/instruccion
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @proyecto/instruccion = Proyecto::Instruccion.find(params[:id])
    @proyecto/instruccion.destroy
    flash[:notice] = "Successfully destroyed proyecto/instruccion."
    redirect_to proyecto/instruccions_url
  end
end
