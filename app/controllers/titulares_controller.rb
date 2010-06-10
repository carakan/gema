class TitularesController < ApplicationController
  def index
    @representantes = Titular.all
  end

  def new
    @representante = Titular.new
  end

  def create

  end

  def edit

  end

  def destroy

  end
end
