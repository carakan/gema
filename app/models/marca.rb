class Marca < ActiveRecord::Base
  belongs_to :clase

  def to_s
    nombre
  end
end
