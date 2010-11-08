class AddConsultasDescartada < ActiveRecord::Migration
  def self.up
    add_column :consultas, :descartada, :boolean, :default => false
  end

  def self.down
    remove_column :consultas, :descartada
  end
end
