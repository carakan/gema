ActiveRecord::Schema.define(:version => 0) do
  create_table :roles, :force => true do |t|
    t.string :nombre, :limit => 100
    t.string :descripcion

    t.timestamps
  end

  create_table :permisos, :force => true do |t|
    t.integer :rol_id
    t.string :controlador, :limit => 150
    t.string :acciones

    t.timestamps
  end
end
