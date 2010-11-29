# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class MarcasController < ApplicationController
  before_filter :revisar_permiso!

  def index
    @marcas = Marca.paginacion(params)
  end

  def new
    @tipo = params[:tipo]
    @tipo_signo = params[:a]
    @marca = Marca.new(:estado_fecha => Date.today, :tipo_signo_id => TipoSigno.find_by_sigla(params[:tipo]).id, :estado => 'pp', :propia => true, :activa => true)
  end

  def edit
    @marca = Marca.find(params[:id])
    unless params[:importacion_id].nil?
      Marca.set_include_estado(@marca.estado)
    end
    @marca.valid?
  end


  def create
    @marca = Marca.crear_instancia(params[:marca])

    if @marca.save
      redirect_to @marca, :notice => 'Se ha salvado correctamente'
    else
#      flash[:error] = "Existio un error al salvar los datos"
      render :action => 'new'
    end
  end

  def update
    @marca = Marca.find(params[:id])
    if @marca.update_marca(params[:marca])
      redireccionar_udpate @marca
    else
      render :action => 'edit'
    end
  end

  def show
    @marca = Marca.find(params[:id])
    @post = @marca.posts.build()
  end

  def ver
    @marca = Marca.find(params[:id])
  end

  def create_post()
    @post = Post.new(params[:post])

    if @post.save
      redirect_to marca_url(@post.marca_id)
    else
      @marca = Marca.find(@post.marca_id)
      render :action => 'show'
    end
  end

  def destroy
    @marca = Marca.find(params[:id])
    @marca.destroy

    render :text => 'Ok'
  end

  private

  def redireccionar_udpate(marca)
    unless params[:importacion_id].nil?
      redirect_to importacion_url(params[:importacion_id])
    else
      redirect_to marca
    end
  end

end
