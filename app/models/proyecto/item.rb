class Proyecto::Item < ActiveRecord::Base
  #attr_accessible :sigla, :nombre, :codigo_categoria
  #attr_accessible :categoria_id, :sigla, :nombre
  set_table_name "items"
  has_many :items_relaciones
  has_many :proyecto_items, :trougth => :items_relaciones, :source => :proyecto_item
  has_ancestry
  
  def to_s
    sigla
  end

end

