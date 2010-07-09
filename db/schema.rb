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

ActiveRecord::Schema.define(:version => 20100709165249) do

  create_table "agentes", :force => true do |t|
    t.string   "nombre"
    t.string   "email"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "movil"
    t.string   "type"
    t.boolean  "valido"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agentes", ["nombre"], :name => "index_agentes_on_nombre"

  create_table "agentes_marcas", :id => false, :force => true do |t|
    t.integer "agente_id"
    t.integer "marca_id"
  end

  add_index "agentes_marcas", ["agente_id", "marca_id"], :name => "index_agentes_marcas_on_agente_id_and_marca_id", :unique => true
  add_index "agentes_marcas", ["agente_id"], :name => "index_agentes_marcas_on_agente_id"
  add_index "agentes_marcas", ["marca_id"], :name => "index_agentes_marcas_on_marca_id"

  create_table "clases", :force => true do |t|
    t.string   "nombre"
    t.integer  "codigo",      :null => false
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marcas", :force => true do |t|
    t.integer  "parent_id",                        :default => 0
    t.integer  "usuario_id"
    t.integer  "titular_id"
    t.integer  "agente_id"
    t.integer  "tipo_signo_id"
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
    t.string   "cambios"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "anterior",                         :default => false
    t.boolean  "propia",                           :default => false
    t.string   "nombre_minusculas"
  end

  add_index "marcas", ["agente_id"], :name => "index_marcas_on_agente_id"
  add_index "marcas", ["clase_id"], :name => "index_marcas_on_clase_id"
  add_index "marcas", ["fecha_importacion"], :name => "index_marcas_on_fecha_importacion"
  add_index "marcas", ["nombre_minusculas"], :name => "index_marcas_on_nombre_minusculas"
  add_index "marcas", ["parent_id"], :name => "index_marcas_on_parent_id"
  add_index "marcas", ["propia"], :name => "index_marcas_on_propia"
  add_index "marcas", ["tipo_marca_id"], :name => "index_marcas_on_tipo_marca_id"
  add_index "marcas", ["tipo_signo_id"], :name => "index_marcas_on_tipo_signo_id"
  add_index "marcas", ["titular_id"], :name => "index_marcas_on_titular_id"
  add_index "marcas", ["type"], :name => "index_marcas_on_type"
  add_index "marcas", ["usuario_id"], :name => "index_marcas_on_usuario_id"

  create_table "marcas_titulares", :id => false, :force => true do |t|
    t.integer "marca_id"
    t.integer "titular_id"
  end

  add_index "marcas_titulares", ["marca_id", "titular_id"], :name => "index_marcas_titulares_on_marca_id_and_titular_id", :unique => true
  add_index "marcas_titulares", ["marca_id"], :name => "index_marcas_titulares_on_marca_id"
  add_index "marcas_titulares", ["titular_id"], :name => "index_marcas_titulares_on_titular_id"

  create_table "paises", :force => true do |t|
    t.string   "nombre",     :limit => 30
    t.string   "codigo",     :limit => 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_marcas", :force => true do |t|
    t.string   "nombre",      :limit => 100
    t.string   "sigla",       :limit => 5
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_signos", :force => true do |t|
    t.string   "sigla",      :limit => 10
    t.string   "nombre",     :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "titulares", :force => true do |t|
    t.string   "nombre"
    t.string   "email"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "movil"
    t.string   "type"
    t.boolean  "valido"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "titulares", ["nombre"], :name => "index_titulares_on_nombre"

  create_table "usuarios", :force => true do |t|
    t.string   "nombre"
    t.string   "rol",           :limit => 20
    t.string   "login",         :limit => 16
    t.string   "email"
    t.string   "password",      :limit => 40
    t.string   "password_salt", :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "view_importaciones", :id => false, :force => true do |t|
    t.datetime "fecha_importacion"
    t.integer  "total",             :limit => 8, :default => 0, :null => false
    t.integer  "errores",           :limit => 8, :default => 0, :null => false
    t.string   "estado"
  end

  create_table "view_importaciones_errores", :id => false, :force => true do |t|
    t.datetime "fecha_importacion"
    t.integer  "total",                          :default => 0, :null => false
    t.integer  "errores",           :limit => 8, :default => 0, :null => false
    t.string   "estado"
  end

  create_table "view_importaciones_todos", :id => false, :force => true do |t|
    t.datetime "fecha_importacion"
    t.integer  "total",             :limit => 8, :default => 0, :null => false
    t.integer  "errores",                        :default => 0, :null => false
    t.string   "estado"
  end

end
