class AddMarcaEstadosModulo < ActiveRecord::Migration
  def self.up
    add_column :marca_estados, :modulo, :string
  end

  def self.down
    remove_column :marca_estados, :modulo, :string
  end
end
