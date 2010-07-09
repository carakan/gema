class PaisesController < ApplicationController
  # GET /paises
  # GET /paises.xml
  def index
    @paises = Pais.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paises }
    end
  end

  # GET /paises/1
  # GET /paises/1.xml
  def show
    @pais = Pais.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pais }
    end
  end

  # GET /paises/new
  # GET /paises/new.xml
  def new
    @pais = Pais.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pais }
    end
  end

  # GET /paises/1/edit
  def edit
    @pais = Pais.find(params[:id])
  end

  # POST /paises
  # POST /paises.xml
  def create
    @pais = Pais.new(params[:pais])

    respond_to do |format|
      if @pais.save
        format.html { redirect_to(@pais, :notice => 'Pais was successfully created.') }
        format.xml  { render :xml => @pais, :status => :created, :location => @pais }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pais.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /paises/1
  # PUT /paises/1.xml
  def update
    @pais = Pais.find(params[:id])

    respond_to do |format|
      if @pais.update_attributes(params[:pais])
        format.html { redirect_to(@pais, :notice => 'Pais was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pais.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /paises/1
  # DELETE /paises/1.xml
  def destroy
    @pais = Pais.find(params[:id])
    @pais.destroy

    respond_to do |format|
      format.html { redirect_to(paises_url) }
      format.xml  { head :ok }
    end
  end
end
