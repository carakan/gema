class CreateContactos < ActiveRecord::Migration
  def self.up
    create_table :contactos do |t|
      t.integer :representante_id
      t.string :nombre
      t.string :cargo
      t.string :telefono
      t.string :email

      t.timestamps
    end
    add_index :contactos, :representante_id
  end

  def self.down
    drop_table :contactos
  end
end
