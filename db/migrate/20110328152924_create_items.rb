class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :categoria_id
      t.string :sigla
      t.string :nombre
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
