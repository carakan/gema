class Titular < Representante
  has_and_belongs_to_many :marcas, 
    :foreign_key => :representante_id,
    :join_table => 'marcas_representantes'
end
