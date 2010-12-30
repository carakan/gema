# encoding: utf-8
# author: Carlos Ramos aka carakan
# email: carakan@gmail.com
class VistaMarca < ActiveRecord::Base
  set_table_name "v_marcas_atomizadas"
  belongs_to :marca, :foreign_key => "id"
end
