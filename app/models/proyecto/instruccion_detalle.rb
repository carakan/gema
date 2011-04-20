class Proyecto::InstruccionDetalle < ActiveRecord::Base
  attr_accessible :instruccion_id, :usuario_id, :tarea, :fecha_limite, :estado, :descripcion_entrega
  set_table_name "instruccion_detalles"
  belongs_to :instruccion
  has_and_belongs_to_many :item_cobros, :association_foreign_key => :proyecto_item_id
  belongs_to :usuario
  has_many :adjuntos, :as => :adjuntable, :dependent => :destroy
  accepts_nested_attributes_for :adjuntos

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
  
#  aasm_event :aprobar do
#    if calificacion > 10
#      transitions :to => :aprobado, :from => [:revision]
#    else
#      transitions :to => :reprobado, :from => [:revision]
#    end
#  end
end
