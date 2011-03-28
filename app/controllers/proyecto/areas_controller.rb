class Proyecto::AreasController < ApplicationController
  def index
    @proyecto/areas = Proyecto::Area.all
  end
  
  def show
    @proyecto/area = Proyecto::Area.find(params[:id])
  end
  
  def new
    @proyecto/area = Proyecto::Area.new
  end
  
  def create
    @proyecto/area = Proyecto::Area.new(params[:proyecto/area])
    if @proyecto/area.save
      flash[:notice] = "Successfully created proyecto/area."
      redirect_to @proyecto/area
    else
      render :action => 'new'
    end
  end
  
  def edit
    @proyecto/area = Proyecto::Area.find(params[:id])
  end
  
  def update
    @proyecto/area = Proyecto::Area.find(params[:id])
    if @proyecto/area.update_attributes(params[:proyecto/area])
      flash[:notice] = "Successfully updated proyecto/area."
      redirect_to @proyecto/area
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @proyecto/area = Proyecto::Area.find(params[:id])
    @proyecto/area.destroy
    flash[:notice] = "Successfully destroyed proyecto/area."
    redirect_to proyecto/areas_url
  end
end
