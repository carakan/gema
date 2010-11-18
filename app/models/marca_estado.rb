# encoding: utf-8
class MarcaEstado < ActiveRecord::Base
  has_many :marcas

  # busca el estado que se relaciona con la importacion
  def self.buscar_estado(estado)
    case estado
    when 'sm' then MarcaEstado.find_by_abreviacion('pp').id
    when 'lp' then MarcaEstado.find_by_abreviacion('pubpo').id
    when 'lr' then MarcaEstado.find_by_abreviacion('rpecr').id
    when 'sr' then MarcaEstado.find_by_abreviacion('rppsr').id
    when 'rc' then MarcaEstado.find_by_abreviacion('renpecr').id
    end
  end
end
