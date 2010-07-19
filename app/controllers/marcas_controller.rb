class MarcasController < ApplicationController
  before_filter :authenticate_user!
  before_filter :add_params_agentes_titulares

  def index
    @marcas = Marca.buscar(:page => @page, :params => params)
  end

  def new
    @tipo = params[:tipo]
    @marca = Marca.new(:estado_fecha => Date.today)
  end

  def edit
    @marca = Marca.find(params[:id])
  end


  def create
    @marca = Marca.crear_instancia(params[:marca])
    if @marca.save
      redirect_to @marca, :notice => 'Se ha salvado correctamente'
    else
      render :action => 'new'
    end
  end

  def update
    @marca = Marca.find(params[:id])
    if @marca.update_marca(params[:marca])
      redirect_to marca_url(@marca.id)
    else
      render :action => 'edit'
    end
  end

  def show
    @marca = Marca.find(params[:id])
    @post = @marca.posts.build
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

end
