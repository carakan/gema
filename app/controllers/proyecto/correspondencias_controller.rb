class Proyecto::CorrespondenciasController < ApplicationController
  def index
    @correspondencias = Correspondencia.all
  end

  def show
    @correspondencia = Correspondencia.find(params[:id])
  end

  def new
    @correspondencia = Correspondencia.new
  end

  def create
    @correspondencia = Correspondencia.new(params[:correspondencia])
    if @correspondencia.save
      redirect_to [:proyecto, @correspondencia], :notice => "Successfully created correspondencia."
    else
      render :action => 'new'
    end
  end

  def edit
    @correspondencia = Correspondencia.find(params[:id])
  end

  def update
    @correspondencia = Correspondencia.find(params[:id])
    if @correspondencia.update_attributes(params[:correspondencia])
      redirect_to [:proyecto, @correspondencia], :notice  => "Successfully updated correspondencia."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @correspondencia = Correspondencia.find(params[:id])
    @correspondencia.destroy
    redirect_to proyecto_correspondencias_url, :notice => "Successfully destroyed correspondencia."
  end
end
