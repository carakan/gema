class Proyecto::TipoInstruccionesController < ApplicationController
  def index
    @tipo_instrucciones = TipoInstruccion.all
  end

  def show
    @tipo_instruccion = TipoInstruccion.find(params[:id])
  end

  def new
    @tipo_instruccion = TipoInstruccion.new
  end

  def create
    @tipo_instruccion = TipoInstruccion.new(params[:tipo_instruccion])
    if @tipo_instruccion.save
      redirect_to [:proyecto, @tipo_instruccion], :notice => "Successfully created tipo instruccion."
    else
      render :action => 'new'
    end
  end

  def edit
    @tipo_instruccion = TipoInstruccion.find(params[:id])
  end

  def update
    @tipo_instruccion = TipoInstruccion.find(params[:id])
    if @tipo_instruccion.update_attributes(params[:tipo_instruccion])
      redirect_to [:proyecto, @tipo_instruccion], :notice  => "Successfully updated tipo instruccion."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tipo_instruccion = TipoInstruccion.find(params[:id])
    @tipo_instruccion.destroy
    redirect_to proyecto_tipo_instrucciones_url, :notice => "Successfully destroyed tipo instruccion."
  end
end