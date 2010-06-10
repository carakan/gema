# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100610231636) do

  create_table "clases", :force => true do |t|
    t.string   "nombre"
    t.integer  "codigo",      :null => false
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marcas", :force => true do |t|
    t.integer  "marca_id"
    t.integer  "usuario_id"
    t.integer  "titular_id"
    t.integer  "agente_id"
    t.integer  "tipo_marca_id"
    t.integer  "clase_id"
    t.string   "numero_solicitud",   :limit => 40
    t.string   "nombre"
    t.string   "numero_registro"
    t.string   "numero_renovacion"
    t.string   "productos"
    t.string   "estado"
    t.date     "estado_fecha"
    t.string   "estado_serial"
    t.string   "numero_publicacion"
    t.string   "numero_gaceta"
    t.string   "lema"
    t.string   "imagen"
    t.date     "fecha_publicacion"
    t.string   "type"
    t.integer  "fila"
    t.datetime "fecha_importacion"
    t.boolean  "activo"
    t.boolean  "valido"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marcas", ["agente_id"], :name => "index_marcas_on_agente_id"
  add_index "marcas", ["clase_id"], :name => "index_marcas_on_clase_id"
  add_index "marcas", ["marca_id"], :name => "index_marcas_on_marca_id"
  add_index "marcas", ["tipo_marca_id"], :name => "index_marcas_on_tipo_marca_id"
  add_index "marcas", ["titular_id"], :name => "index_marcas_on_titular_id"
  add_index "marcas", ["usuario_id"], :name => "index_marcas_on_usuario_id"

  create_table "reprensentates", :force => true do |t|
    t.string   "nombre",     :limit => 150
    t.string   "email"
    t.string   "direccion"
    t.string   "telefono",   :limit => 20
    t.string   "type",       :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reprensentates", ["nombre"], :name => "index_reprensentates_on_nombre"

  create_table "representantes", :force => true do |t|
    t.string   "nombre"
    t.string   "email"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "type"
    t.boolean  "valido"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "representantes", ["nombre"], :name => "index_representantes_on_nombre"

  create_table "tipo_marcas", :force => true do |t|
    t.string   "sigla",      :limit => 10
    t.string   "nombre",     :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
