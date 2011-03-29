class Proyecto::ProyectoItemsController < ApplicationController
  def index
    @proyecto_items = Proyecto::ProyectoItem.all
  end
  
  def show
    @proyecto_item = Proyecto::ProyectoItem.find(params[:id])
  end
  
  def new
    @proyecto_item = Proyecto::ProyectoItem.new
  end
  
  def create
    @proyecto_item = Proyecto::ProyectoItem.new(params[:proyecto_proyecto_item])
    if @proyecto_item.save
      flash[:notice] = "Successfully created proyecto/proyecto item."
      redirect_to @proyecto_item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @proyecto_item = Proyecto::ProyectoItem.find(params[:id])
  end
  
  def update
    @proyecto_item = Proyecto::ProyectoItem.find(params[:id])
    if @pproyecto_item.update_attributes(params[:proyecto_proyecto_item])
      flash[:notice] = "Successfully updated proyecto/proyecto item."
      redirect_to @proyecto_item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @proyecto_item = Proyecto::ProyectoItem.find(params[:id])
    @proyecto_item.destroy
    flash[:notice] = "Successfully destroyed proyecto/proyecto item."
    redirect_to proyecto_proyecto_items_url
  end
end
