class Proyecto::ProyectoItem < ActiveRecord::Base
  attr_accessible :codigo, :proyecto_id, :descripcion, :estado, :referencia_cliente, :referencia_cliente_cobranza, :fecha_limite, :honorarios, :gastos_adminitrativos, :monto, :fecha_solicitud
  belongs_to :proyecto
  belongs_to :item
  has_and_belongs_to_many :marcas
  set_table_name 'proyecto_items'
end
