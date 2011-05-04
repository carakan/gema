class AddSiglaToTipoInstruccion < ActiveRecord::Migration
  def self.up
    add_column :tipo_instrucciones, :sigla, :string
  end

  def self.down
    remove_column :tipo_instrucciones, :sigla
  end
end
