class AddInstruccionAreaId < ActiveRecord::Migration
  def self.up
    add_column :instruccions, :area_id, :integer
  end

  def self.down
    remove_column :instruccions, :area_id
  end
end