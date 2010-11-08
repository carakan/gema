class CreateTipoSignos < ActiveRecord::Migration
  def self.up
    create_table :tipo_signos do |t|
      t.string :sigla, :limit => 10
      t.string :nombre, :limit => 50

      t.timestamps
    end
  end

  def self.down
    drop_table :tipo_marcas
  end
end
