class Proyecto::ProyectosController < ApplicationController
  def index
    @proyectos = Proyecto.all
  end

  def show
    @proyecto = Proyecto.find(params[:id])
  end

  def new
    @proyecto = Proyecto.new
  end

  def create
    @proyecto = Proyecto.new(params[:proyecto])
    if @proyecto.save
      redirect_to [:proyecto, @proyecto], :notice => "Successfully created proyecto."
    else
      render :action => 'new'
    end
  end

  def edit
    @proyecto = Proyecto.find(params[:id])
  end

  def update
    @proyecto = Proyecto.find(params[:id])
    if @proyecto.update_attributes(params[:proyecto])
      redirect_to [:proyecto, @proyecto], :notice  => "Successfully updated proyecto."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @proyecto = Proyecto.find(params[:id])
    @proyecto.destroy
    redirect_to proyecto_proyectos_url, :notice => "Successfully destroyed proyecto."
  end
end
