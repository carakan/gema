class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :marca_id
      t.integer :agente_ids
      t.integer :usuario_id
      t.string :titulo, :limit => 255
      t.string :comentario, :limit => 2058
      t.string :accesso
      t.boolean :adjuntos, :default => false # Indica si tiene adjuntos

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
