class ChangeTipoDatoNroprioridadMarcas < ActiveRecord::Migration
  def self.up
    change_table :marcas do |t|
      t.change :numero_prioridad, :string, :default => ""
    end
  end

  def self.down
    change_table :marcas do |t|
      t.change :numero_prioridad, :string
    end
  end
end
