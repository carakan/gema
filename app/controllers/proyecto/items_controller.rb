class Proyecto::ItemsController < ApplicationController
  def index
    @items = Proyecto::Item.find(:all)
  end

  def show
    @item = Proyecto::Item.find(params[:id])
  end

  def new
    @item = Proyecto::Item.new(:parent_id => params[:parent_id])
  end

  def create
    @item = Proyecto::Item.new(params[:proyecto_item])
    if @item.save
      flash[:notice] = "Se creo exitosamente Item"
      redirect_to proyecto_items_url()
   else
      render :action => 'new'
    end
  end

  def edit
    @item = Proyecto::Item.find(params[:id])
  end

  def update
    @item = Proyecto::Item.find(params[:id])
    if @item.update_attributes(params[:proyecto_item])
      flash[:notice] = "Se actualizo exitosamente Item"
      redirect_to proyecto_items_url()
    else
      render :action => 'edit'
    end
  end

  def destroy
    @item = Proyecto::Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Se elimino exitosamente Item"
    redirect_to proyecto_items_url()
  end
end

