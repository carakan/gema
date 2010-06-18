class AgentesController < ApplicationController

  def index
    @agentes = Agente.all
    respond_to do |format|
      format.html # index.html.erb
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

  
end
