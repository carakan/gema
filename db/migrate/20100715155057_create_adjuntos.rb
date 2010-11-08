class CreateAdjuntos < ActiveRecord::Migration
  def self.up
    create_table :adjuntos do |t|
      t.string :nombre
      t.integer :adjuntable_id
      t.string :adjuntable_type
      t.string :archivo_file_name
      t.integer :archivo_file_size

      t.timestamps
    end

    add_index :adjuntos, :adjuntable_id
    add_index :adjuntos, :adjuntable_type
  end

  def self.down
    drop_table :adjuntos
  end
end
