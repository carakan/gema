class CreateRepresentantes < ActiveRecord::Migration
  def self.up
    create_table :representantes do |t|
      t.string :nombre
      t.string :email
      t.string :direccion
      t.string :telefono
      t.string :movil
      t.string :fax
      t.string :pagina_web
      t.string :type
      t.boolean :valido
      t.string :pais_nombre
      t.string :pais_codigo

      t.timestamps
    end

    add_index :representantes, :nombre
  end

  def self.down
    drop_table :representantes
  end
end
