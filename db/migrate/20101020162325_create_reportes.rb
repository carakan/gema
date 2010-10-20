class CreateReportes < ActiveRecord::Migration
  def self.up
    create_table :reportes do |t|
      t.text :texto_en
      t.text :texto_es
      t.timestamps
    end
  end

  def self.down
    drop_table :reportes
  end
end
