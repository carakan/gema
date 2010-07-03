# coding: utf-8
# Clase que se utiliza para poder otener las expresiones necesarias
# en una busqueda
class Busqueda

  attr_reader :busqueda

  def initialize(busq)
    @busqueda = busq.downcase
    @expresiones = {1 => [], 2 => [], 3 => [], 4 => []}
    @expresiones[1] << busqueda
  end

  # @param String busq
  def self.buscar(busqueda)

    case 
    when busqueda.size <= 3
      include TresLetras
    when busqueda.size == 4
      include CuatroLetras
      include BusquedaCambio
    when busqueda.size == 5
      include CincoLetras
      include BusquedaCambio
    when busqueda.size >= 6
      include BuscarPorGrupo
      include BusquedaCambio
    end

    new(busqueda)
  end

  def dividir_partes
    
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
    @expresiones << {3 => impar}
    @expresiones << {3 => par}
  end

  def expresiones
    buscar_equivalencias
    filtrar_vacios
    @expresiones
  end

  def filtrar_vacios
    @expresiones.each{ |k, val| @expresiones.delete(k) if val.blank? }
  end


end
