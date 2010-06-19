class AgentesController < ApplicationController

  def index
    @agentes = Agente.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @agentes }
    end   
  end

   def show
    @agentes = Agentes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @agentes }
    end
  end
  
  def new
   @agentes = Agente.new

   respond_to do |format|
     format.html # new.html.erb
     format.xml  { render :xml => @agentes}
   end 
  end

  def edit
    @agentes = Agente.find(params[:id])
  end

  def destroy
    @agentes = Agente.find(params[:id])
    @agentes.destroy

    respond_to do !format!
      format.html { redirect_to(agentes_url)}
      format.xml { head :ok}
    end
  end

  def create
    @agentes = Agente.new(params[:agente])

    respond_to do |format|
      if @agentes.save
        format.html { redirect_to(@agentes, :notice => 'El agente fue creado con exito.') }
        format.xml  { render :xml => @agentes, :status => :created, :location => @agentes }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @agentes.errors, :status => :unprocessable_entity }
      end
    end
  end
 
  def update
    @agentes = Agente.find(params[:id])

    respond_to do |format|
      if @agentes.update_attributes(params[:agente])
        format.html { redirect_to(@agentes, :notice => 'Datos del agente actualizados con exito.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @agentes.errors, :status => :unprocessable_entity }
      end
    end
  end


  
end
