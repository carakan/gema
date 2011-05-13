class AddColumnToInstruccionDetalle < ActiveRecord::Migration
  def self.up
    add_column :instruccion_detalles, :fecha_inicio, :date
    add_column :instruccion_detalles, :fecha_fin, :date
    add_column :instruccion_detalles, :periodo, :string
  end

  def self.down
    remove_column :instruccion_detalles, :periodo
    remove_column :instruccion_detalles, :fecha_fin
    remove_column :instruccion_detalles, :fecha_inicio
  end
end
