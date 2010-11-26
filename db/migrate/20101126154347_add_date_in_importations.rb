class AddDateInImportations < ActiveRecord::Migration
  def self.up
    change_table :importaciones do |t|
      t.datetime :fecha_limite
    end
  end

  def self.down
    change_table :importaciones do |t|
      t.remove :fecha_limite
    end
  end
end
