class Consulta < ActiveRecord::Base
  belongs_to :marca
  belongs_to :usuario
end
