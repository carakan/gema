class HomeController < ApplicationController
  def index
    @proyectos = Proyecto::Proyecto.paginate(:per_page => 10, :page => params[:page])
    @revisiones = Proyecto::InstruccionDetalle.revision(current_usuario, params[:page])
    @pendientes = Proyecto::InstruccionDetalle.pendientes(current_usuario, params[:page])
    @mistareas = Proyecto::InstruccionDetalle.mistareas(current_usuario, params[:page])
  end

end
