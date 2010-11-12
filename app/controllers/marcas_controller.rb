# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class MarcasController < ApplicationController
  before_filter :revisar_permiso!
  before_filter :add_params_agentes_titulares

  def index
    nombre_marca = (params[:nombre_marca] || "")
    cond = [ "nombre_minusculas LIKE ?", "%#{nombre_marca.downcase}%" ] 
    p = {
      #:include => [:clase, :tipo_signo, :titulares],
      :include => [:tipo_signo, :titulares],
      :conditions => cond,
    }.merge(order_query_params("marcas.nombre_minusculas"))

    @marcas = Marca.paginate(p)
  end

  def new
    @tipo = params[:tipo]
    @a = params[:a]
#    @tipo_marca = params[:tipo_marca]
    @marca = Marca.new(:estado_fecha => Date.today, :tipo_signo_id => TipoSigno.find_by_sigla(params[:tipo]).id)#, :tipo_marca_id => TipoMarca.find_by_sigla(params[:tipo_marca]).id)
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

  # Adiciona parametros para agentes y titulares
  def add_params_agentes_titulares
    if ['update', 'create'].include?(params[:action])
      params[:marca][:agente_ids] = params[:agente_ids]
      params[:marca][:titular_ids] = params[:titular_ids]
    end
  end

  def redireccionar_udpate(marca)
    unless params[:importacion_id].nil?
      redirect_to importacion_url(params[:importacion_id])
    else
      redirect_to marca
    end
  end

end
