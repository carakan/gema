# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ListaController < ApplicationController
  def index
    params[:page]
    @marcas = Marca.paginate(:page => params[:page], :per_page => 30)
  end
end
