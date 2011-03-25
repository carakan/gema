class Proyecto::ItemCobro < ActiveRecord::Base
  attr_accessible :referencia_cliente, :referencia_cliente_cobranza, :fecha_limite, :honorarios, :gastos_administrativos
end
