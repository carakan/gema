class Proyecto::Proyecto < ActiveRecord::Base
  #attr_protected :representante_id, :area_id, :titulo, :referencia_cliente, :prioridad, :contacto_id
  set_table_name "proyectos"
  belongs_to :area
  belongs_to :representante
  belongs_to :usuario
  has_and_belongs_to_many :contactos, :join_table => :proyectos_contactos
  has_many :correspondencias
  has_many :instruccions, :include => :instruccion_detalles
  has_many :proyecto_items
  has_many :items_relaciones, :through=> :proyecto_items ,:order=>'proyecto_item_id ASC'
  # TODO use a condition for select correct values
  has_many :item_cobros, :class_name => "Proyecto::ItemCobro", :conditions => {:tipo=> 1 }
  has_many :item_gastos, :class_name => "Proyecto::ItemGasto" , :conditions => {:tipo=> 0 }

  accepts_nested_attributes_for :item_gastos
  accepts_nested_attributes_for :item_cobros

  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy

  accepts_nested_attributes_for :adjuntos, :allow_destroy => true
  accepts_nested_attributes_for :correspondencias, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :proyecto_items, :allow_destroy => true
  accepts_nested_attributes_for :instruccions, :allow_destroy => true

  after_save :update_position_on_tree

  def to_s
    "P#{"%04d" % self.id}"
  end

  def fecha_minima
    fechas = []
    self.instruccions.each do |instruccion|
      instruccion.tareas_pendientes.each do |tarea|
        fechas << tarea.fecha_limite
      end
    end
    fechas.min
  end

  def fecha_maxima
    fechas = []
    self.instruccions.each do |instruccion|
      instruccion.tareas_pendientes.each do |tarea|
        fechas << tarea.fecha_limite
      end
    end
    fechas.max
  end

  def estado_proyecto
    estados =[]
    self.instruccions.each do |instruccion|
      instruccion.instruccion_detalles.each do |tarea|
        estados << tarea.estado_tarea
      end
    end

    if estados.include?("pendiente")
      "pendiente"
    else
      if estados.empty?
        "Vacio"
      else
        "terminado"
      end
    end
  end
  
  def obtener_codigo
    codigo = Proyecto::Proyecto.select("max(id) as conteo").first
    return(codigo.conteo + 1)
  rescue
    1
  end
  
  def todas_las_tareas(page = 1)
    Proyecto::InstruccionDetalle.find(:all, :conditions => {:ancestry => nil, :instruccion_id => self.instruccions.collect{|i| i.id }})
  end
  
  def todos_los_adjuntos
    Adjunto.find(:all, :conditions => ["(adjuntable_type = 'Proyecto::Proyecto' AND adjuntable_id = ?) OR (adjuntable_type = 'Proyecto::Correspondencia' AND adjuntable_id in (?))", self.id, self.correspondencia_ids])
  end

  protected

  def update_position_on_tree
    self.instruccions.each do |instruccion|
      if instruccion.temporal_correspondencia_id
        self.correspondencias.each do |correspondencia|
          if correspondencia.temporal_id == instruccion.temporal_correspondencia_id
            instruccion.referencia_email = correspondencia.id
            instruccion.save
          end
        end
      end
      instruccion.instruccion_detalles.each do |tarea|
        tarea.asignado_por = self.usuario
        if tarea.temporal_parent_id
          instruccion.instruccion_detalles.each do |parent|
            if parent.temporal_id == tarea.temporal_parent_id
              tarea.parent = parent
            end
          end
        end
        tarea.save
      end
    end
  end
end

