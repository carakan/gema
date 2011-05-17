class Proyecto::InstruccionDetalle < ActiveRecord::Base
  # TODO research for enable adjuntos atributtes in instruccion_detalle
  #attr_accessible :instruccion_id, :usuario_id, :tarea, :fecha_limite, :estado, :descripcion_entrega
  set_table_name "instruccion_detalles"
  belongs_to :instruccion
  has_and_belongs_to_many :item_cobros, :association_foreign_key => :proyecto_item_id
  belongs_to :usuario
  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
  accepts_nested_attributes_for :adjuntos
  belongs_to :tipo_instruccion
  has_ancestry

  include AASM

  aasm_column :estado_tarea

  aasm_initial_state :pendiente
  aasm_state :pendiente
  aasm_state :revision
  aasm_state :aprobado
  aasm_state :reprobado

  aasm_event :terminar do
    transitions :to => :revision, :from => [:pendiente]
  end

  aasm_event :aprobar do
    transitions :to => :aprobado, :from => [:revision]
  end

  aasm_event :reprobar do
      transitions :to => :reprobado, :from => [:revision]
  end

  def realizar_evaluacion(calificacion)
    if calificacion
      if calificacion > 5
        aprobar!
      else
        reprobar!
      end
    end
  end

  def self.revision(usuario, page = 1)
    self.find(:all, :conditions => {:estado_tarea => 'revision', :asignado_por => usuario}).paginate(:per_page => 5, :page => page)
  end

  def self.mistareas(usuario, page = 1)
    self.find(:all, :conditions=>{:estado_tarea=> 'pendiente', :usuario_id=>usuario}).paginate(:per_page => 5, :page => page)
  end

  def self.pendientes(usuario, page = 1)
    self.find(:all, :conditions => {:estado_tarea => 'pendiente', :asignado_por => usuario}).paginate(:per_page => 5, :page => page)
  end

  def self.aprobado
    if self.estado_tarea == "aprobado"
      true
    end
  end
  
  def to_s
    "P#{"%04d" % self.instruccion.proyecto.id} T#{"%02d" % self.contador}"
  end

  def crear_hijas
    parent_id = self.id
    periodo = self.periodo
    fecha_ini = self.fecha_inicio
    fecha_fin = self.fecha_fin
    fecha_next = fecha_ini

    case periodo
      when "dia"
        while fecha_next < fecha_fin do
          fecha_next = 1.day.since(fecha_next)
          if fecha_next.wday != 0 && fecha_next.wday != 6
            instruccion_detalle = self.clone
            instruccion_detalle.parent = self
            instruccion_detalle.fecha_inicio = fecha_next
            instruccion_detalle.save
          end
        end
      when "semana"
        while fecha_next < fecha_fin do
          fecha_next = 1.week.since(fecha_next)
            instruccion_detalle = self.clone
            instruccion_detalle.parent = self
            instruccion_detalle.fecha_inicio = fecha_next
            instruccion_detalle.save
        end
      when "mes"
        while fecha_next < fecha_fin do
          fecha_next = 1.months.since(fecha_next)
          if fecha_next <= fecha_fin
            if fecha_next.wday == 0
              fecha_next = 1.day.since(fecha_next)
            elsif fecha_next.wday == 6
              fecha_next = 1.day.ago(fecha_next)
            end
            instruccion_detalle = self.clone
            instruccion_detalle.parent = self
            instruccion_detalle.fecha_inicio = fecha_next
            instruccion_detalle.save
          end
        end
      when "anio"
        while fecha_next < fecha_fin do
          fecha_next = 1.years.since(fecha_next)
          if fecha_next <= fecha_fin
            if fecha_next.wday == 0
              fecha_next = 1.day.since(fecha_next)
            elsif fecha_next.wday == 6
              fecha_next = 1.day.ago(fecha_next)
            end
            instruccion_detalle = self.clone
            instruccion_detalle.parent = self
            instruccion_detalle.fecha_inicio = fecha_next
            instruccion_detalle.save
          end
        end
    end
  end
end

