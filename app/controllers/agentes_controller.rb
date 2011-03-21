# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class AgentesController < ApplicationController
  #before_filter :revisar_permiso!

  def index
    @agentes = Agente.paginate(order_query_params)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @agentes }
    end   
  end

   def show
    @agente = Representante.find(params[:id])
    #respond_to do |format|
      #format.html # show.html.erb
      #format.xml  { render :xml => @agentes }
    #end
  end

  def new
   @agente = Agente.new

   respond_to do |format|
     format.html # new.html.erb
     format.xml  { render :xml => @agentes}
   end 
  end

  def edit
    @agente = Agente.find(params[:id])
  end

  def destroy
    @agente = Agente.find(params[:id])
    @agente.destroy

    respond_to do !format!
      format.html { redirect_to(agentes_url)}
      format.xml { head :ok}
    end
  end

  def create
    @agente = Agente.new(params[:agente])

    respond_to do |format|
      if @agente.save
        format.html { redirect_to(@agente, :notice => 'El agente fue creado con exito.') }
        format.xml  { render :xml => @agente, :status => :created, :location => @agente }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @agente.errors, :status => :unprocessable_entity }
      end
    end
  end
 
  def update
    @agente = Agente.find(params[:id])

    respond_to do |format|
      if @agente.update_attributes(params[:agente])
        format.html { redirect_to(@agente, :notice => 'Datos del agente actualizados con exito.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @agente.errors, :status => :unprocessable_entity }
      end
    end
  end


  def buscar
    busq = params[:tag]
    @agentes = Agente.all(:conditions => ["nombre LIKE ?", "%#{busq}%"])
    render :text => @agentes.map{ |a| {:caption => a.nombre, :value => a.id} }.to_json 
  end
  
end
