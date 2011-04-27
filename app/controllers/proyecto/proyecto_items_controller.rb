class Proyecto::ProyectoItemsController < ApplicationController
  before_filter :set_proyecto
  def index
    @proyecto_items = Proyecto::ProyectoItem.paginate(:per_page => 5, :page => params[:page])
  end
  
  def show
    @proyecto_item = Proyecto::ProyectoItem.find(params[:id])
  end
  
  def new
    @proyecto_item = Proyecto::ProyectoItem.new
  end
  
  def create
    @proyecto_item = @proyecto.proyecto_items.new(params[:proyecto_proyecto_item])
    if @proyecto_item.save
      flash[:notice] = "Se creo con exito el servicio."
      redirect_to proyecto_proyecto_url(@proyecto)
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
      flash[:notice] = "Se actualizo correctamente los datos del servicio."
      redirect_to @proyecto_item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @proyecto_item = Proyecto::ProyectoItem.find(params[:id])
    @proyecto_item.destroy
    flash[:notice] = "Se elimino de forma correcta el servicio."
    redirect_to proyecto_proyecto_items_url
  end

  protected
  def set_proyecto
    @proyecto = Proyecto::Proyecto.find(params[:proyecto_id])
  end
end
