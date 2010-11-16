class AddConsultasRepresentanteId < ActiveRecord::Migration
  def self.up
    add_column :consultas, :representante_id, :integer
    add_index :consultas, :representante_id
  end

  def self.down
    remove_column :consultas, :representante_id
  end
end
