class AddTipoInstruccionIdToInstruccionDetall < ActiveRecord::Migration
  def self.up
    add_column :instruccion_detalles, :tipo_instruccion_id, :integer
  end

  def self.down
    remove_column :instruccion_detalles, :tipo_instruccion_id
  end
end
