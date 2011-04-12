class Proyecto::Correspondencia < ActiveRecord::Base
  belongs_to :proyecto
  #validates :contenido, :presence => true
    set_table_name "correspondencias"
end
