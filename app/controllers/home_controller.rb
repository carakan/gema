class HomeController < ApplicationController
  def index
    @proyecto = Proyecto::Proyecto.find(:all)
  end

end
