class Proyecto::Item < ActiveRecord::Base
  attr_accessible :categoria_id, :sigla, :nombre
  set_table_name "items"
end
