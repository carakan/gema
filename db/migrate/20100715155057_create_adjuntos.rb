class CreateAdjuntos < ActiveRecord::Migration
  def self.up
    create_table :adjuntos do |t|
      t.string :nombre
      t.integer :adjuntable_id
      t.string :acjuntable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :adjuntos
  end
end
