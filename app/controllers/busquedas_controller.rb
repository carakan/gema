# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class BusquedasController < ApplicationController
  before_filter :revisar_permiso!

  def index
    @busqueda = []
    params[:tipo_busqueda] = 'prev' if params[:tipo_busqueda].nil?
    if params[:busqueda]
      @busqueda = Busqueda.realizar_busqueda(params)
      @representantes = preparar_representantes()
    end

    @busq = BusquedaVacia.new
  end

  def cruce

    @marca = Marca.find(params[:marca_id])
    query = { :busqueda => @marca.nombre, :clases => (1..45).to_a.join(","), 
      :propia => true, :id => @marca.id, :clase_id => @marca.clase_id }
    @importacion = Importacion.find(params[:importacion_id])
    @consulta = Consulta.find(params[:consulta_id]) unless params[:consulta_id].nil?

    @busqueda = Busqueda.realizar_busqueda(query)

    @representantes = preparar_representantes() # BusquedasController#preparar_representantes
    @busq = BusquedaVacia.new
  end

  def verificar_cruce
    @marca = Marca.find(params[:marca_id])
    query = { :busqueda => @marca.nombre, :clases => (1..45).to_a.join(","), :propia => true }
    @importacion = Importacion.find(params[:importacion_id])

    @busqueda = Busqueda.realizar_busqueda(query)
    @busq = BusquedaVacia.new
  end

private
  def preparar_representantes()
    representante_ids = ( @busqueda.map(&:agente_ids_serial) + @busqueda.map(&:titular_ids_serial) ).uniq
    Representante.where(:id => representante_ids ).inject({})  { |h,v| h[v.id] = v; h } 
  end
end
