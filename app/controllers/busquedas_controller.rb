# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class BusquedasController < ApplicationController
  before_filter :authenticate_usuario!

  # GET /busquedas
  def index
    @titulo = "TG - Búsqueda x similitud" 
    @busqueda = []
    params[:tipo_busqueda] = 'prev' if params[:tipo_busqueda].nil?
    if params[:busqueda]
      if params[:representante] && (params[:representante] == "agente" || params[:representante] == "titular")
        representante_ids = Busqueda.realizar_busqueda({:busqueda => params[:busqueda]}, Representante).collect {|representante| representante.id}
        if params[:representante] == "agente"
          @busqueda = Marca.search(:agentes_id_in => representante_ids)
        else
          @busqueda = Marca.search(:titulares_id_in => representante_ids)
        end
      else
        @busqueda = Busqueda.realizar_busqueda(params)
      end

      @representantes = Busqueda.preparar_representantes(@busqueda)
      # Crea una nueva busqueda con los parametros de la busqueda
      @consulta = Consulta.nueva(params)
    end

    @busq = BusquedaVacia.new
  end

  # GET /busquedas/cruce
  def cruce
    if params[:clases_ids] && !params[:clases_ids].empty?
      clases = params[:clases_ids]
    else
      clases = (1..45).to_a.join(",")
    end
    @marca = Marca.find(params[:marca_id])
    query = { :busqueda => @marca.nombre, :clases => clases,
      :propia => true, :id => @marca.id, :clase_id => @marca.clase_id, :tipo => :cruce }
    @importacion = Importacion.find(params[:importacion_id])

    @busqueda = Busqueda.realizar_busqueda(query)
    @busqueda = @busqueda.collect{ |marca| marca if(((@marca.titular_ids - marca.titular_ids).size == marca.titular_ids.size)||marca.titular_ids.empty?)}.compact
    @busqueda.sort! { |a, b| [a.agente_ids_serial.sort, a.titular_ids_serial.sort] <=> [b.agente_ids_serial.sort, b.titular_ids_serial.sort]  }

    query[:clases] = (1..45).to_a
    @con = Consulta.new(:consulta_id => params[:consulta_id], :busqueda => @marca.nombre, :parametros => query, 
      :importacion_id => params[:importacion_id], :marca_id => params[:marca_id])
    @consulta_detalles = []
    unless params[:consulta_id].nil?
      @consulta = Consulta.find(params[:consulta_id]) 
      @consulta_detalles = @consulta.consulta_detalles.map(&:marca_id)
      @con.comentario = @consulta.comentario
    end

    @representantes = Busqueda.preparar_representantes(@busqueda)
    #@busq = BusquedaVacia.new
  end

  def verificar_cruce
    @marca = Marca.find(params[:marca_id])
    query = { :busqueda => @marca.nombre, :clases => (1..45).to_a.join(","), :propia => true }
    @importacion = Importacion.find(params[:importacion_id])

    @busqueda = Busqueda.realizar_busqueda(query)
    @busq = BusquedaVacia.new
  end

  def busqueda_avanzada
    @titulo = "TG - Búsqueda avanzada" 
    if params[:search]
      prepare_search
      timeout(30){@busqueda_old = Marca.search(params[:search])}
      @representantes = Busqueda.preparar_representantes(@busqueda_old)
      @consulta = Consulta.new(:parametros => params[:search])
      @busqueda = []
      if params[:search]["fecha_registro_btw_any"]
        fecha_inicio = 6.months.ago(Date.parse(params["fecha_ren_pen_inicio"]))
        @busqueda_old.each do |element|
          if element.fecha_renovacion.nil? || element.fecha_renovacion.to_date <= fecha_inicio
            @busqueda << element
          end
        end
      else
        @busqueda_old.each{ |element| @busqueda << element }
      end
      @busqueda_old = nil
      @busqueda.sort! { |a, b| [a.agente_ids_serial.sort, a.titular_ids_serial.sort] <=> [b.agente_ids_serial.sort, b.titular_ids_serial.sort]  }
    else
      @consulta = Consulta.new()
    end
  rescue Timeout::Error => ex
    flash[:notice] = "Existe un error en los criterios de busqueda, la consulta tardo demasiado."
    render :action => :busqueda_avanzada
  rescue => e
    flash[:notice] = "Existe un error en los criterios de busqueda, vuelva a intentarlo. #{e}"
    render :action => :busqueda_avanzada
  end

  private

  def splits_params(name, new_name, split = true)
    if params[:search][name]
      values = params[:search].delete(name)
      if !values.blank?
        values = values.split(" ") if split
        params[:search][new_name] = values
      end
    end
  end

  def prepare_search
    if params[:clases] && !params[:clases].empty?
      params[:search][:clase_id_in] = params[:clases].keys
    end

    if params[:paises] && !params[:paises].empty?
      params[:search][:agentes_pais_codigo_in] = params[:paises].keys
    end

    if params[:paisest] && !params[:paisest].empty?
      params[:search][:titulares_pais_codigo_in] = params[:paisest].keys
    end

    if params[:denominacion] == "exacta"
      splits_params("nombre_marca", :nombre_minusculas_equals, false)
    else
      splits_params("nombre_marca", :nombre_minusculas_contains_all)
    end
    if params[:desc_diseno] == "exacta"
      splits_params("descripcion_diseno", :descripcion_imagen_equals, false)
    else
      splits_params("descripcion_diseno", :descripcion_imagen_contains_all)
    end
    if params[:desc_productos] == "exacta"
      splits_params("descripcion_servicios", :productos_equals, false)
    else
      splits_params("descripcion_servicios", :productos_contains_all)
    end
    if params[:observaciones_m] == "exacta"
      splits_params("observaciones", :observaciones_equals, false)
    else
      splits_params("observaciones", :observaciones_contains_all)
    end
    keys = {"fecha_sol" => "fecha_solicitud", "fecha_pub" => "fecha_publicacion",
      "fecha_reg" => "fecha_registro", "fecha_sol_ren" => "fecha_solicitud_renovacion",
      "fecha_ren" => "fecha_renovacion", "fecha_ren_pen" => "fecha_registro"
    }
    keys.each do |key|
      if params["#{key[0]}_inicio"] && !params["#{key[0]}_inicio"].empty? && params["#{key[0]}_fin"] && !params["#{key[0]}_fin"].empty?
        if key[0] == "fecha_ren_pen"
          fecha_inicio_key = 6.months.ago(Date.parse(params["#{key[0]}_inicio"]))
          fecha_fin_key = 6.months.since(Date.parse(params["#{key[0]}_fin"]))
          fechas = []
          while(fecha_inicio_key.year > 1900 && fecha_fin_key.year > 1900)
            fechas << [fecha_inicio_key, fecha_fin_key]
            fecha_inicio_key = 10.years.ago(fecha_inicio_key)
            fecha_fin_key = 10.years.ago(fecha_fin_key)
          end
          params[:search]["#{key[1]}_btw_any"] = fechas
        else
          params[:search]["#{key[1]}_btw"] = [Date.parse(params["#{key[0]}_inicio"]), Date.parse(params["#{key[0]}_fin"])]
        end
      end
    end

    other_keys = {:sm => ["vista_marca_numero_solicitud_n", "vista_marca_numero_solicitud_a"], "publicacion" => "vista_marca_numero_publicacion", "gaceta" => "numero_gaceta", "registro" => "vista_marca_numero_registro_n",
      :sr => ["vista_marca_numero_solicitud_renovacion_n", "vista_marca_numero_solicitud_renovacion_a"], :renovacion => "vista_marca_numero_renovacion_n", :id => "id"}

    other_keys.each do |key|
      if params["#{key[0]}_inicio"] && !params["#{key[0]}_inicio"].empty?
        if params["#{key[0]}_fin"] && !params["#{key[0]}_fin"].empty?
          if (key[0] == :sm || key[0] == :sr)
            if params["#{key[0]}_inicio"].split("-").size > 1
              params[:search]["#{key[1][0]}_btw"] = [params["#{key[0]}_inicio"].split("-").first.to_i, params["#{key[0]}_fin"].split("-").first.to_i]
              params[:search]["#{key[1][1]}_btw"] = [params["#{key[0]}_inicio"].split("-").last.to_i, params["#{key[0]}_fin"].split("-").last.to_i]
            end
          else
            params[:search]["#{key[1]}_btw"] = [params["#{key[0]}_inicio"].to_i, params["#{key[0]}_fin"].to_i]
          end
        else
          if (key[0] == :sm || key[0] == :sr)
            if params["#{key[0]}_inicio"].split("-").size > 1
              params[:search]["#{key[1][0]}_equals"] = params["#{key[0]}_inicio"].split("-").first.to_i
              params[:search]["#{key[1][1]}_equals"] = params["#{key[0]}_inicio"].split("-").last.to_i
            end
          else
            params[:search]["#{key[1]}_equals"] = params["#{key[0]}_inicio"].to_i
          end
        end
      end
    end

    params[:search].each_with_index do |value, index|
      if value[1] == "all_values"
        params[:search].delete(value[0])
      end
    end
  end
end
