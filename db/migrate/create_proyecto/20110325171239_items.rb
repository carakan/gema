class CreateProyecto::Items < ActiveRecord::Migration
  def self.up
    create_table :proyecto/items do |t|
      t.string :sigla
      t.string :nombre
      t.integer :codigo_categoria
      t.timestamps
    end
  end

  def self.down
    drop_table :proyecto/items
  end
end
