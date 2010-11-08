class CreateMarcasTitulares < ActiveRecord::Migration
  def self.up
    create_table :marcas_titulares, :id => false do |t|
      t.integer :marca_id
      t.integer :titular_id
    end
    add_index :marcas_titulares, :marca_id
    add_index :marcas_titulares, :titular_id
    add_index :marcas_titulares, [ :marca_id, :titular_id ], :unique => true
  end

  def self.down
    drop_table :marcas_titulares
  end
end
