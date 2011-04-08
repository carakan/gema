class Proyecto::AreasController < ApplicationController
  def index
    @areas = Proyecto::Area.all
  end
 
  def show
    @area = Proyecto::Area.find(params[:id])
  end

  def new
    @area = Proyecto::Area.new
  end

  def create
    @area = Proyecto::Area.new(params[:proyecto_area])
    if @area.save
     redirect_to @area ,:notice => "Successfully created area."

    else
      render :action => 'new'
    end
  end
  
  def edit
    @area = Proyecto::Area.find(params[:id])
  end

  def update
    @area = Proyecto::Area.find(params[:id])
    if @area.update_attributes(params[:proyecto_area])
      redirect_to @area, :notice => "Successfully updated proyecto/area."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @area = Proyecto::Area.find(params[:id])
    @area.destroy
    redirect_to proyecto_areas_url,:notice => "Successfully destroyed proyecto/area."
  end
end

