# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class MarcasController < ApplicationController
  #before_filter :revisar_permiso!

  def index
    @marcas = Marca.paginacion(params)
    @titulo = "TG - Listado signos" 
  end

  def new
    @lema_id = params[:lema_marca_id]
    @clase_id = params[:clase_id]
    @tipo_marca = params[:tipo_marca_id]
    @productos = params[:productos]
    if params[:tipo]
      tipo_id = TipoSigno.find_by_sigla(params[:tipo]).id
    elsif params[:tipo_m_id]
      tipo_id = params[:tipo_m_id]
    end
    @marca = Marca.new(:tipo_signo_id => tipo_id, :propia => true, :activa => true, :marca_estado_id => 1, :lema_marca_id => @lema_id, :tipo_marca_id => @tipo_marca, :clase_id => @clase_id, :productos => @productos, :pais_prioridad_id => '999')
  end

  def edit
    @marca = Marca.find(params[:id])
    @marca.valid?
  end

  def create
    @marca = Marca.crear_instancia(params[:marca])
    if @marca.save
      if @marca.lema_marca_id.nil?
        redirect_to @marca, :notice => 'Se ha salvado correctamente'
      else
        flash[:notice] = "Error al guardar" 
        redirect_to marca_path(@marca.lema_marca_id)
      end
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
      flash[:notice] = "error al actualizar"
      render :action => 'edit'
    end
  end

  def show
    @marca = Marca.find(params[:id])
    @post = @marca.posts.build()
    @titulo = "Marca: #{@marca}" 
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

  def quitar_lema
    @lema = Marca.find(params[:lema_id])
    @marca = Marca.find(params[:id])
    @lema.update_attribute(:lema_marca_id, nil)
    redirect_to @marca
  end

  def lemas_comerciales
    @marca = Marca.find(params[:id])
    render :partial=> "listar", :locals=>{:marcas=>Marca.listado_lemas_comerciales}
  end

  def adicionar_lemas
    @marca = Marca.find(params[:id])
    @lema = Marca.find(params[:lema_marca_id])
    @marca.lemas_comerciales << @lema
    redirect_to @marca
  end

  def errores_sm 
   @marcas = Marca.find(:all, :conditions => ["LENGTH(numero_solicitud) <> 10 "] ).paginate(:page =>params[:page], :per_page => 50)
   
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
