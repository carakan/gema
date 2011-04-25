class AddAsignadoPorInstruccionDetalles < ActiveRecord::Migration
 def self.up
    add_column :instruccion_detalles, :asignado_por, :string
  end

   def self.down
    remove_column :instruccion_detalles, :asignado_por
  end
end
