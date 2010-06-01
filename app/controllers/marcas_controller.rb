class MarcasController < ApplicationController
  def edit
    @marca = Marca.find(params[:id])
  end

  def update
  end
end
