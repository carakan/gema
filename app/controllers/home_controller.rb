class HomeController < ApplicationController
  def index
    @proyectos = Proyecto::Proyecto.paginate(:per_page => 10, :page => params[:page])
    @instruccion_detalles = Proyecto::InstruccionDetalle.paginate(:per_page => 10, :page => params[:page])
  end

end
