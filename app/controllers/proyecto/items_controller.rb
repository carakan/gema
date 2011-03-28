class Proyecto::ItemsController < ApplicationController
  def index
    @proyecto/items = Proyecto::Item.all
  end
  
  def show
    @proyecto/item = Proyecto::Item.find(params[:id])
  end
  
  def new
    @proyecto/item = Proyecto::Item.new
  end
  
  def create
    @proyecto/item = Proyecto::Item.new(params[:proyecto/item])
    if @proyecto/item.save
      flash[:notice] = "Successfully created proyecto/item."
      redirect_to @proyecto/item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @proyecto/item = Proyecto::Item.find(params[:id])
  end
  
  def update
    @proyecto/item = Proyecto::Item.find(params[:id])
    if @proyecto/item.update_attributes(params[:proyecto/item])
      flash[:notice] = "Successfully updated proyecto/item."
      redirect_to @proyecto/item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @proyecto/item = Proyecto::Item.find(params[:id])
    @proyecto/item.destroy
    flash[:notice] = "Successfully destroyed proyecto/item."
    redirect_to proyecto/items_url
  end
end
