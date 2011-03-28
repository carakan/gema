class CreateProyecto::Areas < ActiveRecord::Migration
  def self.up
    create_table :proyecto/areas do |t|
      t.string :nombre
      t.integer :sigla
      t.timestamps
    end
  end

  def self.down
    drop_table :proyecto/areas
  end
end
