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


end
