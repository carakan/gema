class CreateClases < ActiveRecord::Migration
  def self.up
    create_table :clases do |t|
      t.string :nombre
      t.integer :codigo, :null => false
      t.string :descripcion

      t.timestamps
    end
  end

  def self.down
    drop_table :clases
  end
end
