class CreateCorrespondencias < ActiveRecord::Migration
  def self.up
    create_table :correspondencias do |t|
      t.integer :proyecto_id
      t.boolean :tipo
      t.text :contenido
      t.timestamps
    end
  end

  def self.down
    drop_table :correspondencias
  end
end
