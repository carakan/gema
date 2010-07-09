class CreatePaises < ActiveRecord::Migration
  def self.up
    create_table :paises do |t|
      t.string :nombre, :limit => 30
      t.string :codigo, :limit => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :paises
  end
end
