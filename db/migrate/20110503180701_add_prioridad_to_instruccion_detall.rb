class AddPrioridadToInstruccionDetall < ActiveRecord::Migration
  def self.up
    add_column :instruccion_detalles, :prioridad, :string, :limit => 1
  end

  def self.down
    remove_column :instruccion_detalles, :prioridad
  end
end