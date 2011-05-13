class Proyecto::ItemsRelacion < ActiveRecord::Base
  belongs_to :item
  belongs_to :proyecto_item
  set_table_name 'items_relaciones'
end
