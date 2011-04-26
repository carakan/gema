class Proyecto::Proyecto < ActiveRecord::Base
  #attr_protected :representante_id, :area_id, :titulo, :referencia_cliente, :prioridad, :contacto_id
  set_table_name "proyectos"
  belongs_to :area
  belongs_to :representante
  has_and_belongs_to_many :contactos, :join_table => :proyectos_contactos
  has_many :correspondencias
  has_many :instruccions, :include => :instruccion_detalles
  has_many :proyecto_items

  # TODO use a condition for select correct values
  has_many :item_cobros, :class_name => "Proyecto::ItemCobro"
  has_many :item_gastos, :class_name => "Proyecto::ItemGasto"

  accepts_nested_attributes_for :item_gastos
  accepts_nested_attributes_for :item_cobros

  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
  
  accepts_nested_attributes_for :adjuntos
  accepts_nested_attributes_for :correspondencias, :reject_if => :all_blank, :allow_destroy => true  
  accepts_nested_attributes_for :proyecto_items
  accepts_nested_attributes_for :instruccions

  def to_s
    id
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
end

