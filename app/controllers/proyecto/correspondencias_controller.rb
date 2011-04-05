class Proyecto::CorrespondenciasController < ApplicationController
  before_filter :set_proyecto
  def index
    @correspondencias = @proyecto.correspondencias.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @correspondencia = @proyecto.correspondencias.find(params[:id])
  end

  def new
    @correspondencia = Proyecto::Correspondencia.new
  end

  def create
    @correspondencia = @proyecto.correspondencias.new(params[:proyecto_correspondencia])
    if @correspondencia.save
      redirect_to proyecto_proyecto_url(@proyecto), :notice => "Successfully created correspondencia."
    else
      render :action => 'new'
    end
  end

  def edit
    @correspondencia = @proyecto.correspondencias.find(params[:id])
  end

  def update
    @correspondencia = @proyecto.correspondencias.find(params[:id])
    if @correspondencia.update_attributes(params[:proyecto_correspondencia])
      redirect_to proyecto_proyecto_url(@proyecto), :notice  => "Successfully updated correspondencia."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @correspondencia = Proyecto::Correspondencia.find(params[:id])
    @correspondencia.destroy
    redirect_to proyecto_proyecto_url(@proyecto), :notice => "Successfully destroyed correspondencia."
  end

  protected
  def set_proyecto
    @proyecto = Proyecto::Proyecto.find(params[:proyecto_id])
  end
end
