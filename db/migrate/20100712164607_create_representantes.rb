class CreateRepresentantes < ActiveRecord::Migration
  def self.up
    create_table :representantes do |t|
      t.integer :pais_id
      t.string :nombre
      t.string :email
      t.string :direccion
      t.string :telefono
      t.string :movil
      t.string :fax
      t.string :pagina_web
      t.string :type
      t.boolean :valido
      t.boolean :cliente, :default => false
      t.string :pais_codigo, :limit => 4 # denormalizado
      t.string :pais_nombre # denormalizado

      t.timestamps
    end

    add_index :representantes, :nombre
    add_index :representantes, :pais_id
  end

  def self.down
    drop_table :representantes
  end
end
