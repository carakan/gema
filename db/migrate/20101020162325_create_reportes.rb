class CreateReportes < ActiveRecord::Migration
  def self.up
    create_table :reportes do |t|
      t.text :texto_en
      t.text :texto_es
      t.string :nombre_clase
      t.timestamps
    end
  end

  def self.down
    drop_table :reportes
  end
end
