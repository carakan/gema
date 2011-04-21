class AddAncestryToInstruccionDetalles < ActiveRecord::Migration
  def self.up
    add_column :instruccion_detalles, :ancestry, :string
    add_index :instruccion_detalles, :ancestry
  end

  def self.down
    remove_column :instruccion_detalles, :ancestry
    remove_column :instruccion_detalles, :ancestry
  end
end
