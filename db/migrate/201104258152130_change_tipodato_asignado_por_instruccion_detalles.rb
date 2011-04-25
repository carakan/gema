class ChangeTipodatoAsignadoPorInstruccionDetalles < ActiveRecord::Migration
  def self.up
    change_table :instruccion_detalles do |t|
      t.change :asignado_por, :integer, :default => nil
    end
  end

  def self.down
    change_table :instruccion_detalles do |t|
      t.change :asignado_por, :integer
    end
  end
 end
