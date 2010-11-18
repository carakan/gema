class CreateMarcaEstados < ActiveRecord::Migration
  def self.up
    create_table :marca_estados do |t|
      t.string :nombre
      t.string :abreviacion, :limit => 15

      t.timestamps
    end
  end

  def self.down
    drop_table :marca_estados
  end
end
