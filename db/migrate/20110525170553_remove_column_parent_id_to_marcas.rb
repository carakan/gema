class RemoveColumnParentIdToMarcas < ActiveRecord::Migration
  def self.up
    remove_column :marcas, :parent_id
    remove_column :marcas, :cambios
    remove_column :marcas, :anterior
  end

  def self.down
    add_column :marcas, :parent_id, :integer
    add_column :marcas, :cambios, :text
    add_column :marcas, :anterior, :integer
  end
end
