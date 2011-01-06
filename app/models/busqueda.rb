# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
##############################
# Clase que se utiliza para poder obtener las expresiones necesarias
# en una busqueda
class Busqueda

  PARAMS = [:clases, :tipo_busqueda, :fecha_ini, :fecha_fin]
  attr_reader :busqueda

  include BusquedaCambio

  def initialize(busq, model = Marca)
    @busqueda = busq.downcase.cambiar_acentos
    @letras = self.class.dividir_palabra(@busqueda)
    @expresiones = { 1 => [], 2 => [], 3 => [], 4 => [] }
    @expresiones[1] << busqueda
    @nombre_modelo = model
  end

  # @param String busq
  def self.buscar(busqueda, model = Marca)
    letras = dividir_palabra(busqueda)

    case 
    when letras.size <= 3
      include TresLetras
    end

    include BuscarPorGrupo

    new(busqueda, model)
  end

  # divide una palabra en un array con los caracteres de la busqueda,
  # debido a que "palabra".size tiene problemas con caracteres utf-8
  #   @param String
  def self.dividir_palabra(busq)
    letras = []
    busq.scan(/.{1}/) { |v| letras << v }
    letras
  end

  # Crea expresiones regulares para la busqueda basado en la logitud de la palabra,
  # para palabras con un numero par o impar de letras
  def expresiones_pares_impares
    par = ''
    impar = ''
    busqueda.chars.each_with_index do |chr, ind|
      unless (ind % 2) == 0
        par << cambiar_caracter_especiales( chr )
        impar << Constants::LETRAS_REG
      else
        par << Constants::LETRAS_REG
        impar << cambiar_caracter_especiales( chr )
      end
    end
    [impar, par]
  end

  # Cambia en caracteres seguros para realizar las busqueda por
  # expresión regular, para que la BD no tenga problemas al crea el SQL
  def cambiar_caracter_especiales(chr)
    if Constants::SPECIAL_CHARS.include?( chr )
      "\\#{chr}"
    else
      chr
    end
  end

  # retorna un array con dos caracteres al inicio y al final
  def silaba_inicio_fin
    [busqueda[0,2], busqueda[-2,2] ]
  end

  # realiza las combinaciones para expresiones
  def expresiones
    #if busqueda.size > 3
    @expresiones[2] = combinaciones_palabra
    @expresiones[3] = expresiones_pares_impares
    #end

    # divide en subgrupos la palabra "BuscarPorGrupo"
    @expresiones[4] = buscar_equivalencias
    if busqueda.size == 5
      @expresiones[4] << silaba_inicio_fin
      @expresiones[4].flatten!
    end

    filtrar_vacios
    @expresiones
  end

  def filtrar_vacios
    @expresiones.each{ |k, val| @expresiones.delete(k) if val.blank? }
  end

  # Transforma las fechas de busqueda de String a Date
  # en caso de que esten correctas devuelve las dos fechas
  # caso contrario retorna un array de false
  def transformar_fechas(params)
    begin
      fecha_ini = params[:fecha_ini].to_date
      fecha_fin = params[:fecha_fin].to_date
      if fecha_ini <= fecha_fin
        [fecha_ini, fecha_fin]
      else
        [false, false]
      end
    rescue
      [false, false]
    end
  end

  # Funcion que se invoca desde el controlador para realizar busquedas
  def self.realizar_busqueda(params, model = Marca)
    b = buscar(params[:busqueda], model)
    result = model.find_by_sql(b.crear_sql(b.expresiones, params) )
    #result.sort! { |a,b| a.agente_ids_serial.sort <=> b.agente_ids_serial.sort }
    result
  end

  # Adiciona las condiciones sql necesarias
  #   @param Hash
  #   @return String
  def condiciones_sql(params)
    if @nombre_modelo == Marca
      if params[:clases].is_a? String
        clases = params[:clases].split(",").map(&:to_i)
      else
        clases = params[:clases].keys.map(&:to_i)
      end

      sql = [ "WHERE res.clase_id IN (#{clases.join(', ')})" ]

      params[:fecha_ini], params[:fecha_fin] = transformar_fechas(params)
      if params[:fecha_ini]
        #sql << "AND estado_fecha >= '#{params[:fecha_ini]}' AND estado_fecha <= '#{params[:fecha_fin]}'"
        sql << "AND fecha_solicitud >= '#{params[:fecha_ini]}' AND fecha_solicitud <= '#{params[:fecha_fin]}'"
      end
      sql << condicion_marca_propia(params)
      sql << condicion_activas
      sql.join(" ")
    end
  end

  #   @param Hash
  #   @return String
  def condicion_marca_propia(params)
    condicion_sql = ""
    if params[:propia].nil?
      condicion_sql
    elsif params[:propia] == "1"
      condicion_sql = "AND res.propia = 1"
    elsif params[:propia] == "0"
      condicion_sql = "AND res.propia = 0"
    end
    return condicion_sql
  end

  def condicion_activas
    "AND res.activa=1"
  end

  # Trabajar en esto
  def condicion_tipo_signo(params)
    #if params[:tipo_signo_id].nil?
    #  ActiveRecord::Base.send(:sanitize_sql_array, [" AND tipo_signo_id IN (%s)", signos])
    #else
    #  ""
    #end
  end

  # Funcion principal que une todas las partes del SQL para crearel query
  #   @param Array
  #   @param Hash
  #   @return String
  def crear_sql(expresiones, params)
    sql_exp = []
    expresiones.each do |pos, exp|
      case pos
      when 1
        sql_exp << sql_exacto(exp.first, pos)
      when 2
        sql_exp << sql_variaciones(exp, pos)
      when 3
        sql_exp << sql_exp_reg(exp, pos)
      when 4
        sql_exp << sql_variaciones(exp, pos)
      end
    end

    busqueda = params[:busqueda].downcase.cambiar_acentos
    if @nombre_modelo == Marca
      sql = "SELECT res.id, res.nombre, res.pos, res.clase_id, res.propia, res.activa, res.tipo_signo_id, res.agente_ids_serial,
      res.fecha_renovacion, res.fecha_solicitud_renovacion, res.fecha_registro,
      res.titular_ids_serial, res.fecha_publicacion, res.numero_solicitud, res.numero_publicacion, 
      res.numero_registro, res.numero_renovacion, res.estado, res.numero_solicitud_renovacion, res.fecha_solicitud, res.exacto"
    else
      sql = "SELECT res.id, res.nombre, res.nombre_minusculas"
    end
    sql << ", IF(#{busqueda.size}>CHAR_LENGTH(res.nombre_minusculas), #{busqueda.size} - CHAR_LENGTH(res.nombre_minusculas),
      CHAR_LENGTH(res.nombre_minusculas) - #{busqueda.size}) AS longitud_letras"
    sql << ", IF(res.id=#{params[:clase_id].to_i}, 0, 2) AS dist_clase_id" unless params[:clase_id].nil?
    sql = [ "#{sql} FROM" ]
    sql << "(#{sql_exp.join(" UNION ")}) AS res"
    if @nombre_modelo == Marca
      sql << condiciones_sql(params)
      sql << condiciones_representante(params) # busqueda por agente o titular
      sql << "AND res.tipo_signo_id NOT IN (2)"
      sql << "GROUP BY res.clase_id, res.id" #if params[:clase_id]
      sql << condiciones_representante(params) # busqueda por agente o titular

      unless params[:clase_id].nil?
        sql << "ORDER BY res.pos, dist_clase_id, longitud_letras ASC"
      else
        sql << "ORDER BY res.exacto, res.clase_id, res.pos, longitud_letras ASC"
      end
    end
    sql.join(" ")
  end

  # Busqueda por agente o titular
  def condiciones_representante(params)
    representantes = []
    marcas = []

    return "" if params[:representante].nil?

    ['agente', 'titular'].each { |v| representantes << v if params[:representante].include?(v) }
    if representantes.any? and params[:representante_id]
      representantes.each do |rep|
        marcas += Representante.find_by_sql("SELECT * FROM marcas_#{rep.pluralize} WHERE #{rep}_id = #{params[:representante_id].to_i}").map(&:marca_id)
      end

      if marcas.any?
        " AND res.id IN (#{marcas.uniq.compact.join(", ")})"
      else
        " AND res.id IN (-1)"
      end
    else
      ""
    end
  end

  def sql_select(pos, exacto = 1)
    if @nombre_modelo == Marca
      "SELECT id, nombre, nombre_minusculas, clase_id, #{pos} AS pos, propia, activa, estado, agente_ids_serial, titular_ids_serial, fecha_publicacion, fecha_renovacion, fecha_solicitud_renovacion, fecha_registro, 
      numero_solicitud, numero_publicacion, numero_registro, numero_renovacion, tipo_signo_id, numero_solicitud_renovacion, fecha_solicitud, #{exacto} AS exacto
      FROM marcas"
    else
      "SELECT * FROM ((SELECT id, nombre, LOWER(nombre) AS nombre_minusculas
       FROM representantes) AS representantes)"
    end
  end

  # SQl que busca la palabra exacata
  #   @param String
  #   @param Integer
  #   @return String
  def sql_exacto(bus, pos)
    condicion = "parent_id = 0 AND" if @nombre_modelo == Marca
    ActiveRecord::Base.send(:sanitize_sql_array,
      [ "(#{sql_select(pos, 0)} WHERE #{condicion} nombre_minusculas = '%s')", bus ]
    )
  end

  # SQl con expresion regular
  #   @param Array
  #   @param Integer
  #   @return String
  def sql_exp_reg(arr, pos)
    condicion = "parent_id = 0 AND" if @nombre_modelo == Marca
    sql = "(#{sql_select(pos)} WHERE #{condicion} ("
    sql << arr.map{
      |v| ActiveRecord::Base.send(:sanitize_sql_array, [ "nombre_minusculas REGEXP '%s'", v ] )
    }.join(" OR ")
    sql << "))"
  end

  # Crea variaciones de la busqueda (palabra)
  #   @param Array
  #   @param Integer
  #   @return String
  def sql_variaciones(arr, pos)
    condicion = "parent_id = 0 AND" if @nombre_modelo == Marca
    sql = "(#{sql_select(pos)} WHERE #{condicion} ("
    sql << arr.map{ |v|
      ActiveRecord::Base.send(:sanitize_sql_array, ["nombre_minusculas LIKE '%s'", "%#{v}%"] )
    }.join(" OR ")
    sql << "))"
  end

  # Metodo para poder preparar un listado de representantes
  def self.preparar_representantes(busqueda)
    results = []
    busqueda.each do |marca|
      results << marca.agente_ids_serial
      results << marca.titular_ids_serial
    end
    results = results.flatten.uniq
    Representante.where(:id => results).inject({})  { |h,v| h[v.id] = v; h }
  end
end
