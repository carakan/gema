class Proyecto::ProyectosController < ApplicationController
  
  def index
    @proyectos = Proyecto::Proyecto.paginate(:page => params[:page], :per_page => 25, :order => "created_at DESC")
    
    respond_to do |format|
      format.html
    end
  end

  def show
    @proyecto = Proyecto::Proyecto.find(params[:id])
    @mistareas = Proyecto::InstruccionDetalle.mistareas(current_usuario, params[:page])
  end

  def new
    @proyecto = Proyecto::Proyecto.new
    #@proyecto.proyecto_items << @proyecto.proyecto_items.build
    #@proyecto.correspondencias << @proyecto.correspondencias.build
    #@proyecto.instruccions << @proyecto.instruccions.build
  end

  def create
    @proyecto = Proyecto::Proyecto.new(params[:proyecto_proyecto])
    if @proyecto.save
      redirect_to @proyecto, :notice => "Se creo con exito el proyecto."
    else
      render :action => 'new'
    end
  end

  def edit
    @proyecto = Proyecto::Proyecto.find(params[:id])
  end

  def update
    @proyecto = Proyecto::Proyecto.find(params[:id])
    if @proyecto.update_attributes(params[:proyecto_proyecto])
      redirect_to @proyecto, :notice  => "Successfully updated proyecto."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @proyecto = Proyecto::Proyecto.find(params[:id])
    @proyecto.destroy
    redirect_to proyecto_proyectos_url, :notice => "Successfully destroyed proyecto."
  end
end

