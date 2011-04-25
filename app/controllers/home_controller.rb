class HomeController < ApplicationController
  def index
    @proyectos = Proyecto::Proyecto.find(:all)
  end

end
