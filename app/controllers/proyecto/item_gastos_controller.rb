class Proyecto::ItemGastosController < ApplicationController
  def index
    @proyecto/item_gastos = Proyecto::ItemGasto.all
  end
  
  def show
    @proyecto/item_gasto = Proyecto::ItemGasto.find(params[:id])
  end
  
  def new
    @proyecto/item_gasto = Proyecto::ItemGasto.new
  end
  
  def create
    @proyecto/item_gasto = Proyecto::ItemGasto.new(params[:proyecto/item_gasto])
    if @proyecto/item_gasto.save
      flash[:notice] = "Successfully created proyecto/item gasto."
      redirect_to @proyecto/item_gasto
    else
      render :action => 'new'
    end
  end
  
  def edit
    @proyecto/item_gasto = Proyecto::ItemGasto.find(params[:id])
  end
  
  def update
    @proyecto/item_gasto = Proyecto::ItemGasto.find(params[:id])
    if @proyecto/item_gasto.update_attributes(params[:proyecto/item_gasto])
      flash[:notice] = "Successfully updated proyecto/item gasto."
      redirect_to @proyecto/item_gasto
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @proyecto/item_gasto = Proyecto::ItemGasto.find(params[:id])
    @proyecto/item_gasto.destroy
    flash[:notice] = "Successfully destroyed proyecto/item gasto."
    redirect_to proyecto/item_gastos_url
  end
end
