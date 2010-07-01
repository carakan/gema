# coding: utf-8
# Clase que se utiliza para poder otener las expresiones necesarias
# en una busqueda
class Busqueda

  attr_reader :busqueda

  def initialize(busq)
    @busqueda = busq.downcase
    @expresiones = [ {1 => "#{busqueda}"} ]
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
    when busqueda.size == 6
      include SeisLetras
    #when busqueda.size == 7
    #  include 'siete_letras'
    #when (8..9).include?( busqueda.size )
    #  include 'ocho_letras'
    #when (10..11).include?( busqueda.size )
    #  include 'diez_letras'
    #when (12..13).include?( busqueda.size)
    #  include 'doce_letras'
    #when (14..15).include?( busqueda.size )
    #  include 'catorce_letras'
    #when (16..20).include?( busqueda.size )
    #  include 'dieciseis_letras'
    end

    new(busqueda)
  end

  def dividir_partes
    
  end

  def expresiones
    buscar_equivalencias
    @expresiones
  end

end
