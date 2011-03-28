class Proyecto::Area < ActiveRecord::Base
  attr_accessible :nombre, :sigla
  set_table_name "areas"
end
