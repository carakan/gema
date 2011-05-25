class Proyecto::Area < ActiveRecord::Base
  attr_accessible :nombre, :sigla, :mostrar
  set_table_name "areas"
  has_many :proyectos
  has_many :usuarios

  def to_s
    self.nombre
  end
end
