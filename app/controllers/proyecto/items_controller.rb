class Proyecto::ItemsController < ApplicationController
  def index
    @items = Proyecto::Item.all
  end
  
  def show
    @item = Proyecto::Item.find(params[:id])
  end
  
  def new
    @item = Proyecto::Item.new
  end
  
  def create
    @item = Proyecto::Item.new(params[:proyecto_item])
    if @item.save
      flash[:notice] = "Se creo exitosamente el item"
      redirect_to @item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @item = Proyecto::Item.find(params[:id])
  end
  
  def update
    @item = Proyecto::Item.find(params[:id])
    if @proyecto/item.update_attributes(params[:proyecto_item])
      flash[:notice] = "Successfully updated proyecto/item."
      redirect_to @item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Proyecto::Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed proyecto/item."
    redirect_to proyecto_items_url
  end
end
