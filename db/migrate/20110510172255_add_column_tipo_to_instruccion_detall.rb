class AddColumnTipoToInstruccionDetall < ActiveRecord::Migration
  def self.up
    add_column :instruccion_detalles, :tipo, :boolean
  end

  def self.down
    remove_column :instruccion_detalles, :tipo
  end
end
