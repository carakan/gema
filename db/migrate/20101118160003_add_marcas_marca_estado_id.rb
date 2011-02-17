class AddMarcasMarcaEstadoId < ActiveRecord::Migration
  def self.up
    add_column :marcas, :marca_estado_id, :integer
  end

  def self.down
    remove_column :marcas, :marca_estado_id
  end
end
