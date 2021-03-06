# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class TitularesController < ApplicationController
  #before_filter :revisar_permiso!

  def index
    @titulares = Titular.paginate( order_query_params( :include => :pais, :order => 'representantes.nombre' ) )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @titulares }
    end   
  end

   def show
    @titular = Titular.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @titular }
    end
  end
  
  def new
   @titular = Titular.new

   respond_to do |format|
     format.html # new.html.erb
     format.xml  { render :xml => @titular}
   end 
  end

  def edit
    @titular = Titular.find(params[:id])
  end

  def destroy
    @titular = Titular.find(params[:id])
    @titular.destroy

    respond_to do !format!
      format.html { redirect_to(titulares_url)}
      format.xml { head :ok}
    end
  end

  def create
    @titular = Titular.new(params[:titular])

    respond_to do |format|
      if @titular.save
        format.html { redirect_to(@titular, :notice => 'El titular fue creado con exito.') }
        format.xml  { render :xml => @titular, :status => :created, :location => @titular }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @titular.errors, :status => :unprocessable_entity }
      end
    end
  end
 
  def update
    @titular = Titular.find(params[:id])

    respond_to do |format|
      if @titular.update_attributes(params[:titular])
        format.html { redirect_to(@titular, :notice => 'Datos del titular actualizados con exito.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @titular.errors, :status => :unprocessable_entity }
      end
    end
  end



  def buscar
    busq = params[:tag]
    @titulares = Titular.all(:conditions => ["nombre LIKE ?", "%#{busq}%"])
    render :text => @titulares.map{ |t| {:caption => t.nombre, :value => t.id} }.to_json 
  end
  
  
end
