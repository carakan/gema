class AddMarcasInstruccion < ActiveRecord::Migration
  def self.up
    add_column :marcas, :instruccion, :string
  end

  def self.down
    remove_column :marcas, :instruccion
  end
end
