# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
##############################
# Clase que se utiliza para poder otener las expresiones necesarias
# en una busqueda
class Busqueda

  PARAMS = [:clases, :tipo_busqueda, :fecha_ini, :fecha_fin]
  attr_reader :busqueda

  include BusquedaCambio

  def initialize(busq)
    @busqueda = busq.downcase.cambiar_acentos
    @letras = self.class.dividir_palabra(@busqueda)
    @expresiones = { 1 => [], 2 => [], 3 => [], 4 => [] }
    @expresiones[1] << busqueda
  end

  # @param String busq
  def self.buscar(busqueda)
    letras = dividir_palabra(busqueda)

    case 
    when letras.size <= 3
      include TresLetras
    end

    include BuscarPorGrupo

    new(busqueda)
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
  def self.transformar_fechas(params)
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
  def self.realizar_busqueda(params)
    b = buscar(params[:busqueda])
    result = Marca.find_by_sql(crear_sql(b.expresiones, params) )
    #result.sort! { |a,b| a.agente_ids_serial.sort <=> b.agente_ids_serial.sort }
    result
  end

  # Adiciona las condiciones sql necesarias
  #   @param Hash
  #   @return String
  def self.condiciones_sql(params)
    if params[:clases].is_a? String
      clases = params[:clases].split(",").map(&:to_i)
    else
      clases = params[:clases].keys.map(&:to_i)
    end

    sql = [ "WHERE res.clase_id IN (#{clases.join(', ')})" ]

    params[:fecha_ini], params[:fecha_fin] = transformar_fechas(params)
    if params[:fecha_ini]
      sql << "AND estado_fecha >= '#{params[:fecha_ini]}' AND estado_fecha <= '#{params[:fecha_fin]}'"
    end
    sql << condicion_marca_propia(params)
    sql << condicion_activas

    sql.join(" ")
  end

  #   @param Hash
  #   @return String
  def self.condicion_marca_propia(params)
    if params[:propia].nil?
      ""
    elsif params[:propia] == true
      "AND res.propia=1"
    elsif params[:propia] == false
      "AND res.propia=0"
    end
  end

  def self.condicion_activas
    "AND res.activa=1"
  end

  # Trabajar en esto
  def self.condicion_tipo_signo(params)
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
  def self.crear_sql(expresiones, params)
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
    sql = "SELECT res.id, res.nombre, res.pos, res.clase_id, res.propia, res.activa, res.tipo_signo_id, res.agente_ids_serial, 
      res.titular_ids_serial, res.fecha_publicacion, res.numero_solicitud, res.numero_publicacion, 
      res.numero_registro, res.numero_renovacion, res.estado, res.numero_solicitud_renovacion, res.estado_fecha, res.exacto"
    sql << ", IF(#{busqueda.size}>CHAR_LENGTH(res.nombre_minusculas), #{busqueda.size} - CHAR_LENGTH(res.nombre_minusculas),
      CHAR_LENGTH(res.nombre_minusculas) - #{busqueda.size}) AS longitud_letras"
    sql << ", IF(res.id=#{params[:clase_id].to_i}, 0, 2) AS dist_clase_id" unless params[:clase_id].nil?
    sql = [ "#{sql} FROM" ]
    sql << "(#{sql_exp.join(" UNION ")}) AS res"
    sql << condiciones_sql(params)
    #sql << "GROUP BY res.clase_id, res.id"
    sql << "AND res.tipo_signo_id NOT IN (2)"

    unless params[:clase_id].nil?
      sql << "ORDER BY res.pos, dist_clase_id, longitud_letras ASC"
    else
      sql << "ORDER BY res.exacto, res.clase_id, res.pos, longitud_letras ASC"
    end
    
    #debugger

    sql.join(" ")
  end

  def self.sql_select(pos, exacto = 1)
    "SELECT id, nombre, nombre_minusculas, clase_id, #{pos} AS pos, propia, activa, estado, agente_ids_serial, titular_ids_serial, fecha_publicacion,
     numero_solicitud, numero_publicacion, numero_registro, numero_renovacion, tipo_signo_id, numero_solicitud_renovacion, estado_fecha, #{exacto} AS exacto
     FROM marcas"
  end

  # SQl que busca la palabra exacata
  #   @param String
  #   @param Integer
  #   @return String
  def self.sql_exacto(bus, pos)
    ActiveRecord::Base.send(:sanitize_sql_array, 
      [ "#{sql_select(pos, 0)} WHERE parent_id = 0 AND nombre_minusculas = '%s'", bus ]
    )
  end

  # SQl con expresion regular
  #   @param Array
  #   @param Integer
  #   @return String
  def self.sql_exp_reg(arr, pos)
    sql = "#{sql_select(pos)} WHERE parent_id = 0 AND ("
    sql << arr.map{ 
      |v| ActiveRecord::Base.send(:sanitize_sql_array, [ "nombre_minusculas REGEXP '%s'", v ] )
    }.join(" OR ")
   sql << ")"
  end

  # Crea variaciones de la busqueda (palabra)
  #   @param Array
  #   @param Integer
  #   @return String
  def self.sql_variaciones(arr, pos)
    sql = "#{sql_select(pos)} WHERE parent_id = 0 AND ("
    sql << arr.map{ |v| 
      ActiveRecord::Base.send(:sanitize_sql_array, ["nombre_minusculas LIKE '%s'", "%#{v}%"] ) 
    }.join(" OR ")
   sql << ")"
  end

  # Metodo para poder preparar un listado de representantes

  def self.preparar_representantes(busqueda)
    representante_ids = ( busqueda.map(&:agente_ids_serial) + busqueda.map(&:titular_ids_serial) ).flatten.uniq
    Representante.where(:id => representante_ids ).inject({})  { |h,v| h[v.id] = v; h } 
  end

end
