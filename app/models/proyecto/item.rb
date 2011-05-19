class Proyecto::Item < ActiveRecord::Base
  #attr_accessible :sigla, :nombre, :codigo_categoria
  #attr_accessible :categoria_id, :sigla, :nombre
  set_table_name "items" 
  has_many :items_relaciones, :class_name => 'Proyecto::ItemsRelacion'
  has_many :proyecto_items, :through => :items_relaciones, :source => :proyecto_item
  has_ancestry
  
  def show_children
    (self.children + Proyecto::Item.where(:sigla => "GA").children).collect{|c| [c.nombre, c.id]}
  rescue
    self.children.collect{|c| [c.nombre, c.id]}
  end
  
  def to_s
    sigla
  end
end