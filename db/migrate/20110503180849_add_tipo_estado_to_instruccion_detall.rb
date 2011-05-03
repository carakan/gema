class AddTipoEstadoToInstruccionDetall < ActiveRecord::Migration
  def self.up
    add_column :instruccion_detalles, :tipo_estado, :string
  end

  def self.down
    remove_column :instruccion_detalles, :tipo_estado
  end
end
