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

ActiveRecord::Schema.define(:version => 20100816112409) do

  create_table "adjuntos", :force => true do |t|
    t.string   "nombre"
    t.integer  "adjuntable_id"
    t.string   "adjuntable_type"
    t.string   "archivo_file_name"
    t.integer  "archivo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clases", :force => true do |t|
    t.string   "nombre"
    t.integer  "codigo",      :null => false
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consulta_detalles", :force => true do |t|
    t.integer  "consulta_id"
    t.integer  "marca_id"
    t.string   "comentario",  :limit => 800
    t.integer  "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consultas", :force => true do |t|
    t.integer  "marca_id"
    t.integer  "usuario_id"
    t.string   "busqueda"
    t.string   "parametros",     :limit => 400
    t.string   "comentario",     :limit => 400
    t.string   "reporte"
    t.integer  "importacion_id",                :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "descartada",                    :default => false
  end

  create_table "contactos", :force => true do |t|
    t.string   "nombre"
    t.string   "cargo"
    t.string   "telefono"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "importaciones", :force => true do |t|
    t.boolean  "completa"
    t.string   "publicacion",       :limit => 30
    t.string   "archivo_file_name"
    t.integer  "archivo_file_size"
    t.integer  "cruces_pendientes",               :default => -1
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marcas", :force => true do |t|
    t.integer  "parent_id",                                  :default => 0
    t.integer  "usuario_id"
    t.integer  "tipo_signo_id"
    t.integer  "tipo_marca_id"
    t.integer  "clase_id"
    t.integer  "pais_id"
    t.string   "numero_solicitud",           :limit => 40
    t.string   "nombre"
    t.string   "numero_registro",                            :default => ""
    t.date     "fecha_registro"
    t.string   "numero_renovacion",                          :default => ""
    t.string   "productos",                  :limit => 1024, :default => ""
    t.string   "estado",                                     :default => ""
    t.date     "estado_fecha"
    t.string   "estado_serial"
    t.string   "numero_publicacion",                         :default => ""
    t.string   "numero_gaceta",                              :default => ""
    t.string   "lema",                                       :default => ""
    t.date     "fecha_publicacion"
    t.integer  "fila"
    t.datetime "fecha_importacion"
    t.boolean  "valido"
    t.string   "cambios",                                    :default => "--- []\n\n"
    t.boolean  "importado",                                  :default => false
    t.string   "apoderado"
    t.string   "representante_empresarial"
    t.integer  "importacion_id"
    t.boolean  "activa",                                     :default => true
    t.string   "archivo_adjunto",                            :default => ""
    t.date     "fecha_solicitud_renovacion"
    t.date     "fecha_instruccion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "anterior",                                   :default => false
    t.boolean  "propia",                                     :default => false
    t.string   "nombre_minusculas"
    t.string   "agente_ids_serial"
    t.string   "titular_ids_serial"
    t.string   "errores",                    :limit => 700
    t.string   "errores_manual",             :limit => 500
  end

  add_index "marcas", ["activa"], :name => "index_marcas_on_activa"
  add_index "marcas", ["clase_id"], :name => "index_marcas_on_clase_id"
  add_index "marcas", ["fecha_importacion"], :name => "index_marcas_on_fecha_importacion"
  add_index "marcas", ["importacion_id"], :name => "index_marcas_on_importacion_id"
  add_index "marcas", ["importado"], :name => "index_marcas_on_importado"
  add_index "marcas", ["nombre_minusculas"], :name => "index_marcas_on_nombre_minusculas"
  add_index "marcas", ["pais_id"], :name => "index_marcas_on_pais_id"
  add_index "marcas", ["parent_id"], :name => "index_marcas_on_parent_id"
  add_index "marcas", ["propia"], :name => "index_marcas_on_propia"
  add_index "marcas", ["tipo_marca_id"], :name => "index_marcas_on_tipo_marca_id"
  add_index "marcas", ["tipo_signo_id"], :name => "index_marcas_on_tipo_signo_id"
  add_index "marcas", ["usuario_id"], :name => "index_marcas_on_usuario_id"

  create_table "marcas_representantes", :id => false, :force => true do |t|
    t.integer "marca_id"
    t.integer "representante_id"
  end

  add_index "marcas_representantes", ["marca_id", "representante_id"], :name => "index_marcas_representantes_on_marca_id_and_representante_id", :unique => true
  add_index "marcas_representantes", ["marca_id"], :name => "index_marcas_representantes_on_marca_id"
  add_index "marcas_representantes", ["representante_id"], :name => "index_marcas_representantes_on_representante_id"

  create_table "paises", :force => true do |t|
    t.string   "nombre",     :limit => 30
    t.string   "codigo",     :limit => 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "marca_id"
    t.integer  "usuario_id"
    t.string   "titulo"
    t.string   "comentario", :limit => 2058
    t.string   "accesso"
    t.boolean  "adjuntos",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "representantes", :force => true do |t|
    t.string   "nombre"
    t.string   "email"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "movil"
    t.string   "fax"
    t.string   "pagina_web"
    t.string   "type"
    t.boolean  "valido"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pais_id"
  end

  add_index "representantes", ["nombre"], :name => "index_representantes_on_nombre"
  add_index "representantes", ["pais_id"], :name => "index_representantes_on_pais_id"

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
    t.integer "importacion_id"
    t.integer "total",          :limit => 8, :default => 0, :null => false
    t.integer "errores",        :limit => 8, :default => 0, :null => false
    t.string  "estado"
  end

  create_table "view_importaciones_errores", :id => false, :force => true do |t|
    t.integer "importacion_id"
    t.integer "total",                       :default => 0,  :null => false
    t.integer "errores",        :limit => 8, :default => 0,  :null => false
    t.string  "estado",                      :default => ""
  end

  create_table "view_importaciones_todos", :id => false, :force => true do |t|
    t.integer "importacion_id"
    t.integer "total",          :limit => 8, :default => 0,  :null => false
    t.integer "errores",                     :default => 0,  :null => false
    t.string  "estado",                      :default => ""
  end

end
