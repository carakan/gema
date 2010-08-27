class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :postable_id
      t.string :postable_type
      t.integer :usuario_id
      t.string :titulo, :limit => 255
      t.string :comentario, :limit => 2058
      t.integer :accesso
      t.boolean :adjuntos, :default => false # Indica si tiene adjuntos

      t.timestamps
    end

    add_index :posts, :postable_id
    add_index :posts, :postable_type
  end

  def self.down
    drop_table :posts
  end
end
