class AddDateInImportations < ActiveRecord::Migration
  def self.up
    change_table :importaciones do |t|
      t.datetime :fecha_limite
      t.datetime :fecha_limite_orpan
    end
  end

  def self.down
    change_table :importaciones do |t|
      t.remove :fecha_limite, :fecha_limite_orpan
    end
  end
end
