class Agente < ActiveRecord::Base
  has_and_belongs_to_many :marcas

end
