class Proyecto::ItemsRelacionesController < ApplicationController
before_filter :set_proyecto
  def new
   @item_relaciones = @proyecto
  end

protected
  def set_proyecto
    @proyecto = Proyecto::Proyecto.find(params[:proyecto_id])
  end
end