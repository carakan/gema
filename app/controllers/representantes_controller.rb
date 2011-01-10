# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class RepresentantesController < ApplicationController
  before_filter :revisar_permiso!
  # GET /representantes
  # GET /representantes.xml
  def index
    @representantes = Representante.where(["representantes.nombre LIKE ?", "%#{ params[:search] }%"])
    @representantes = @representantes.where(:cliente => true) if params[:cliente]
    @representantes = @representantes.includes(:pais).paginate( :page => @page )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @representantes }
    end
  end

  # GET /representantes/1
  # GET /representantes/1.xml
  def show
    @representante = Representante.find(params[:id])
    @post = @representante.posts.build()
    #respond_to do |format|
    #format.html # show.html.erb
    #format.xml  { render :xml => @representante }
    #end
  end

  def create_post()
    @post = Post.new(params[:post])

    if @post.save
      redirect_to representante_url(@post.representante_id)
    else
      @representante = Representante.find(@post.representante_id)
      render :action => 'show'
    end
  end


  # GET /representantes/new
  # GET /representantes/new.xml
  def new
    @representante = Representante.new(:cliente => true)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @representante }
    end
  end

  # GET /representantes/1/edit
  def edit
    @representante = Representante.find(params[:id])
  end

  # POST /representantes
  # POST /representantes.xml
  def create
    @representante = Representante.new(params[:representante])

    respond_to do |format|
      if @representante.save
        format.html { redirect_to(@representante, :notice => 'Representante was successfully created.') }
        format.xml  { render :xml => @representante, :status => :created, :location => @representante }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @representante.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /representantes/1
  # PUT /representantes/1.xml
  def update
    @representante = Representante.find(params[:id])

    respond_to do |format|
      if @representante.update_attributes(params[:representante])
        format.html { redirect_to(@representante, :notice => 'Representante was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @representante.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /representantes/1
  # DELETE /representantes/1.xml
  def destroy
    @representante = Representante.find(params[:id])
    @representante.destroy

    respond_to do |format|
      format.html { redirect_to(representantes_url) }
      format.xml  { head :ok }
    end
  end

  def buscar()
    if params[:tag]
      busq = params[:tag]
      hash_proc = lambda { |c| { :value => c.id, :key => c.to_s } }
    else
      busq = params[:term]
      hash_proc = lambda { |c| { :id => c.id, :label => c.to_s } }
    end
    if params[:all]
      @clientes = Representante.where("nombre LIKE ?", "%#{busq}%").limit(50).order("nombre")
    else
      @clientes = Representante.clientes.where("nombre LIKE ?", "%#{busq}%").limit(50).order("nombre")
    end
    render :text => @clientes.map{ |c| hash_proc.call(c) }.to_json 
  end
end
