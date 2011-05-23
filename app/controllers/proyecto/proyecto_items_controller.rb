class Proyecto::ProyectoItemsController < ApplicationController
  before_filter :set_proyecto
  def index
    @proyecto_items = Proyecto::ProyectoItem.paginate(:per_page => 5, :page => params[:page])
  end

  def show
    @proyecto_item = Proyecto::ProyectoItem.find(params[:id])
  end

  def new
    if params[:tipo] && params[:tipo] == "cobro"
      @proyecto_item = @proyecto.item_cobros.new
    elsif params[:tipo] && params[:tipo] == "gasto"
      @proyecto_item = @proyecto.item_gastos.new
    else
      @proyecto_item = @proyecto.proyecto_items.new
    end
  end

  def create
    if params[:proyecto_proyecto_item]
      parametros = params[:proyecto_proyecto_item]
    elsif params[:proyecto_item_cobro]
      parametros = params[:proyecto_item_cobro]
    elsif params[:proyecto_item_gasto]
      parametros = params[:proyecto_item_gasto]
    end
    @proyecto_item = @proyecto.proyecto_items.new(parametros)
    if @proyecto_item.save
      flash[:notice] = "Se creo con exito el servicio."
      redirect_to @proyecto
      #redirect_to proyecto_proyecto_url(@proyecto)
    else
      render :action => 'new'
    end
  end

  def edit
    if params[:tipo] && params[:tipo] == "cobro"
      @proyecto_item = @proyecto.item_cobros.find(params[:id])
    elsif params[:tipo] && params[:tipo] == "gasto"
      @proyecto_item = @proyecto.item_gastos.find(params[:id])
    else
      @proyecto_item = @proyecto.proyecto_items.find(params[:id])
    end
  end

  def update
    if params[:proyecto_proyecto_item]
      parametros = params[:proyecto_proyecto_item]
    elsif params[:proyecto_item_cobro]
      parametros = params[:proyecto_item_cobro]
    elsif params[:proyecto_item_gasto]
      parametros = params[:proyecto_item_gasto]
    end
    
    @proyecto_item = @proyecto.proyecto_items.find(params[:id])
    if @proyecto_item.update_attributes(parametros)
      flash[:notice] = "Se actualizo correctamente los datos del servicio."
      redirect_to proyecto_proyecto_path(@proyecto)
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

