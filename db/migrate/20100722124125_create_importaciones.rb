class CreateImportaciones < ActiveRecord::Migration
  def self.up
    create_table :importaciones do |t|
      t.boolean :completa

      t.timestamps
    end
  end

  def self.down
    drop_table :importaciones
  end
end
