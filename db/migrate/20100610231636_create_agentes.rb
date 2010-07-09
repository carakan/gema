class CreateAgentes < ActiveRecord::Migration
  def self.up
    create_table :agentes do |t|
      t.string :nombre
      t.string :email
      t.string :direccion
      t.string :telefono
      t.string :movil
      t.string :type
      t.boolean :valido

      t.timestamps
    end

    add_index :agentes, :nombre
  end

  def self.down
    drop_table :agentes
  end
end
