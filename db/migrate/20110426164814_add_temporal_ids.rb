class AddTemporalIds < ActiveRecord::Migration
  def self.up
    add_column :instruccion_detalles, :temporal_id, :integer, :limit => 8
    add_column :instruccion_detalles, :temporal_parent_id, :integer, :limit => 8

    add_column :correspondencias, :temporal_id, :integer, :limit => 8
    add_column :instruccions, :temporal_correspondencia_id, :integer, :limit => 8
  end

  def self.down
    remove_column :instruccion_detalles, :temporal_id
    remove_column :instruccion_detalles, :temporal_parent_id

    remove_column :correspondencias, :temporal_id
    remove_column :instruccions, :temporal_correspondencia_id
  end
end
