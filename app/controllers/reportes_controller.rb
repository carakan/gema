class ReportesController < ApplicationController
  def index
    @reportes = Reporte.all
  end
  
  def show
    @reporte = Reporte.find(params[:id])
  end
  
  def new
    @reporte = Reporte.new
  end
  
  def create
    @reporte = Reporte.new(params[:reporte])
    if @reporte.save
      flash[:notice] = "Successfully created reporte."
      redirect_to @reporte
    else
      render :action => 'new'
    end
  end
  
  def edit
    @reporte = Reporte.find(params[:id])
  end
  
  def update
    @reporte = Reporte.find(params[:id])
    if @reporte.update_attributes(params[:reporte])
      flash[:notice] = "Successfully updated reporte."
      redirect_to @reporte
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @reporte = Reporte.find(params[:id])
    @reporte.destroy
    flash[:notice] = "Successfully destroyed reporte."
    redirect_to reportes_url
  end
end
