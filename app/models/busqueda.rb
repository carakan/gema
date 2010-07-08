# coding: utf-8
# Clase que se utiliza para poder otener las expresiones necesarias
# en una busqueda
class Busqueda

  attr_reader :busqueda

  include BusquedaCambio

  def initialize(busq)
    @busqueda = busq.downcase.cambiar_acentos
    @expresiones = { 1 => [], 2 => [], 3 => [], 4 => [] }
    @expresiones[1] << busqueda
  end

  # @param String busq
  def self.buscar(busqueda)

    case 
    when busqueda.size <= 3
      include TresLetras
    when busqueda.size == 4
      include CuatroLetras
    when busqueda.size == 5
      include CincoLetras
    when busqueda.size >= 6
      include BuscarPorGrupo
    end

    new(busqueda)
  end


  def expresiones_pares_impares
    par = ''
    impar = ''
    busqueda.chars.each_with_index do |chr, ind|
      unless (ind % 2) == 0
        par << chr
        impar << Constants::LETRAS_REG
      else
        par << Constants::LETRAS_REG
        impar << chr
      end
    end
    [impar, par]
  end

  def silaba_inicio_fin
    [busqueda[0,2], busqueda[-2,2] ]
  end

  def expresiones
    if busqueda.size > 3
      @expresiones[2] = combinaciones_palabra
      @expresiones[3] = expresiones_pares_impares
    end

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

    sql = crear_sql(b.expresiones) + " " + condiciones_sql(params) + " GROUP BY nombre"
  end

  # Adiciona las condiciones sql necesarias
  def self.condiciones_sql(params)
    clases = params[:clases].split(",").map(&:strip).map(&:to_i)
    sql = "WHERE clase_id in (#{clases.join(', ')})"

    params[:fecha_ini], params[:fecha_fin] = transformar_fechas(params)
    if params[:fecha_ini]
      sql << " AND fecha >= '#{params[:fecha_ini]}' AND fecha <= '#{params[:fecha_fin]}'"
    end

    sql
  end

  def self.crear_sql(expresiones)
    sql = []
    expresiones.each do |pos, exp|
      case pos
        when 1
          sql << sql_exacto(exp.first, pos)
        when 2
          sql << sql_variaciones(exp, pos)
        when 3
          sql << sql_expreg(exp, pos)
        when 4
          sql << sql_variaciones(exp, pos)
      end
    end
    "SELECT nombre, pos FROM (#{sql.join(" UNION ")}) AS res"
  end

  def self.sql_exacto(bus, pos)
    sql = "SELECT nombre, clase_id, #{pos} AS pos FROM marcas WHERE nombre_minusculas = '#{bus}'"
  end

  def self.sql_variaciones(arr, pos)
    sql = "SELECT nombre, clase_id, #{pos} AS pos FROM marcas WHERE "
    sql << arr.map{ |v| "nombre_minusculas LIKE '%#{v}%'" }.join(" OR ")
  end

  def self.sql_expreg(arr, pos)
    sql = "SELECT nombre, clase_id, #{pos} AS pos FROM marcas WHERE "
    sql << arr.map{ |v| "nombre_minusculas REGEXP '#{v}'" }.join(" OR ")
  end

end
