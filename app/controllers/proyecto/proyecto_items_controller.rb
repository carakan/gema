class Proyecto::ProyectoItemsController < ApplicationController
  def index
    @proyecto/proyecto_items = Proyecto::ProyectoItem.all
  end
  
  def show
    @proyecto/proyecto_item = Proyecto::ProyectoItem.find(params[:id])
  end
  
  def new
    @proyecto/proyecto_item = Proyecto::ProyectoItem.new
  end
  
  def create
    @proyecto/proyecto_item = Proyecto::ProyectoItem.new(params[:proyecto/proyecto_item])
    if @proyecto/proyecto_item.save
      flash[:notice] = "Successfully created proyecto/proyecto item."
      redirect_to @proyecto/proyecto_item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @proyecto/proyecto_item = Proyecto::ProyectoItem.find(params[:id])
  end
  
  def update
    @proyecto/proyecto_item = Proyecto::ProyectoItem.find(params[:id])
    if @proyecto/proyecto_item.update_attributes(params[:proyecto/proyecto_item])
      flash[:notice] = "Successfully updated proyecto/proyecto item."
      redirect_to @proyecto/proyecto_item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @proyecto/proyecto_item = Proyecto::ProyectoItem.find(params[:id])
    @proyecto/proyecto_item.destroy
    flash[:notice] = "Successfully destroyed proyecto/proyecto item."
    redirect_to proyecto/proyecto_items_url
  end
end
