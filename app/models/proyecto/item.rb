class Proyecto::Item < ActiveRecord::Base
  attr_accessible :sigla, :nombre, :codigo_categoria
  attr_accessible :categoria_id, :sigla, :nombre
  set_table_name "items"
  has_many :proyecto_items

  def to_s
    sigla
  end
end
