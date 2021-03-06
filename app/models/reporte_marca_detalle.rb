# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class ReporteMarcaDetalle < ActiveRecord::Base
  belongs_to :reporte_marca
  belongs_to :marca_propia, :class_name => 'Marca', :foreign_key => :marca_id
  belongs_to :marca_foranea, :class_name => 'Marca', :foreign_key => :marca_foranea_id

  validates_length_of :comentario, :minimum => 5, :unless => lambda { |r| r.comentario.blank? }

end
