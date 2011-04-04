class Proyecto::CorrespondenciasController < ApplicationController
  before_filter :set_proyecto
  def index
    @correspondencias = Proyecto::Correspondencia.all
  end

  def show
    @correspondencia = Proyecto::Correspondencia.find(params[:id])
  end

  def new
    @correspondencia = Proyecto::Correspondencia.new
  end

  def create
    @correspondencia = Proyecto::Correspondencia.new(params[:proyecto_correspondencia])
    if @correspondencia.save
      redirect_to @correspondencia, :notice => "Successfully created correspondencia."
    else
      render :action => 'new'
    end
  end

  def edit
    @correspondencia = Proyecto::Correspondencia.find(params[:id])
  end

  def update
    @correspondencia = Proyecto::Correspondencia.find(params[:id])
    if @correspondencia.update_attributes(params[:proyecto_correspondencia])
      redirect_to @correspondencia, :notice  => "Successfully updated correspondencia."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @correspondencia = Proyecto::Correspondencia.find(params[:id])
    @correspondencia.destroy
    redirect_to proyecto_correspondencias_url, :notice => "Successfully destroyed correspondencia."
  end

  protected
  def set_proyecto
    @proyecto = Proyecto::Proyecto.find(params[:proyecto_id])
  end
end
