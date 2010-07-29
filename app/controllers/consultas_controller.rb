class ConsultasController < ApplicationController
  # GET /consultas
  # GET /consultas.xml
  def index
    @consultas = Consulta.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultas }
    end
  end

  # GET /consultas/1
  # GET /consultas/1.xml
  def show
    @consulta = Consulta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consulta }
    end
  end

  # GET /consultas/new
  # GET /consultas/new.xml
  def new
    @consulta = Consulta.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consulta }
    end
  end

  # GET /consultas/1/edit
  def edit
    @consulta = Consulta.find(params[:id])
  end

  # POST /consultas
  # POST /consultas.xml
  def create
    @consulta = Consulta.new(params[:consulta])

    respond_to do |format|
      if @consulta.save
        format.html { redirect_to(@consulta, :notice => 'Consulta was successfully created.') }
        format.xml  { render :xml => @consulta, :status => :created, :location => @consulta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consulta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /consultas/1
  # PUT /consultas/1.xml
  def update
    @consulta = Consulta.find(params[:id])

    respond_to do |format|
      if @consulta.update_attributes(params[:consulta])
        format.html { redirect_to(@consulta, :notice => 'Consulta was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consulta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /consultas/1
  # DELETE /consultas/1.xml
  def destroy
    @consulta = Consulta.find(params[:id])
    @consulta.destroy

    respond_to do |format|
      format.html { redirect_to(consultas_url) }
      format.xml  { head :ok }
    end
  end
end
