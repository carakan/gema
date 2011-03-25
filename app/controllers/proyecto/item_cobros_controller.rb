class Proyecto::ItemCobrosController < ApplicationController
  def index
    @proyecto/item_cobros = Proyecto::ItemCobro.all
  end
  
  def show
    @proyecto/item_cobro = Proyecto::ItemCobro.find(params[:id])
  end
  
  def new
    @proyecto/item_cobro = Proyecto::ItemCobro.new
  end
  
  def create
    @proyecto/item_cobro = Proyecto::ItemCobro.new(params[:proyecto/item_cobro])
    if @proyecto/item_cobro.save
      flash[:notice] = "Successfully created proyecto/item cobro."
      redirect_to @proyecto/item_cobro
    else
      render :action => 'new'
    end
  end
  
  def edit
    @proyecto/item_cobro = Proyecto::ItemCobro.find(params[:id])
  end
  
  def update
    @proyecto/item_cobro = Proyecto::ItemCobro.find(params[:id])
    if @proyecto/item_cobro.update_attributes(params[:proyecto/item_cobro])
      flash[:notice] = "Successfully updated proyecto/item cobro."
      redirect_to @proyecto/item_cobro
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @proyecto/item_cobro = Proyecto::ItemCobro.find(params[:id])
    @proyecto/item_cobro.destroy
    flash[:notice] = "Successfully destroyed proyecto/item cobro."
    redirect_to proyecto/item_cobros_url
  end
end
