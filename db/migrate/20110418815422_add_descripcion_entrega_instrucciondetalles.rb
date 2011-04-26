class AddDescripcionEntregaInstrucciondetalles < ActiveRecord::Migration
  def self.up
    add_column :instruccion_detalles, :descripcion_entrega, :text
  end

   def self.down
    remove_column :instruccion_detalles, :descripcion_entrega
  end
end
