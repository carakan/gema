class CreateTitulares < ActiveRecord::Migration
  def self.up
    create_table :titulares do |t|
      t.string :nombre
      t.string :email
      t.string :direccion
      t.string :telefono
      t.string :movil
      t.string :type
      t.boolean :valido

      t.timestamps
    end

    add_index :titulares, :nombre
  end

  def self.down
    drop_table :titulares
  end
end
