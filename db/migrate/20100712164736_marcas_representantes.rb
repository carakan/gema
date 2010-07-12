class MarcasRepresentantes < ActiveRecord::Migration
  def self.up
    create_table :marcas_representantes, :id => false do |t|
      t.integer :marca_id
      t.integer :representante_id
    end

    add_index :marcas_representantes, [:marca_id, :representante_id], :unique => true
    add_index :marcas_representantes, :marca_id
    add_index :marcas_representantes, :representante_id
  end

  def self.down
    drop_table :marcas_representantes
  end
end
