class Proyecto::ProyectosController < ApplicationController
  def index
    @proyectos = Proyecto::Proyecto.paginate(:per_page => 10, :page => params[:page], :order => "created_at DESC")
    respond_to do |format|
    format.html
    format.json do
      render(:json => Proyecto::Proyecto.for_data_table(self, %w(id representante_id area_id titulo referencia_cliente prioridad), %w(id representante)) do |proyecto|
        ["<%= link_to(proyecto, proyecto) %>", proyecto.id, proyecto.representante_id, proyecto.area_id, proyecto.titulo, proyecto.referencia_cliente, proyecto.prioridad]
      end)
    end
    end
  end

  def show
    @proyecto = Proyecto::Proyecto.find(params[:id])
    @mistareas = Proyecto::InstruccionDetalle.mistareas(current_usuario, params[:page])
  end

  def new
    @proyecto = Proyecto::Proyecto.new
    #@proyecto.proyecto_items << @proyecto.proyecto_items.build
    #@proyecto.correspondencias << @proyecto.correspondencias.build
    #@proyecto.instruccions << @proyecto.instruccions.build
  end

  def create
    @proyecto = Proyecto::Proyecto.new(params[:proyecto_proyecto])
    if @proyecto.save
      redirect_to @proyecto, :notice => "Se creo con exito el proyecto."
    else
      render :action => 'new'
    end
  end

  def edit
    @proyecto = Proyecto::Proyecto.find(params[:id])
  end

  def update
    @proyecto = Proyecto::Proyecto.find(params[:id])
    if @proyecto.update_attributes(params[:proyecto_proyecto])
      redirect_to @proyecto, :notice  => "Successfully updated proyecto."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @proyecto = Proyecto::Proyecto.find(params[:id])
    @proyecto.destroy
    redirect_to proyecto_proyectos_url, :notice => "Successfully destroyed proyecto."
  end
end

