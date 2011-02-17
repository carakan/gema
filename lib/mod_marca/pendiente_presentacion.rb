# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
module ModMarca::PendientePresentacion
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
    base.set_validations_and_filters
  end

  module InstanceMethods
    private
      def validar_agente
        self.errors.add(:agente_ids, "Debe seleccionar al menos un agente") if self.agente_ids.blank?
      end

      def validar_titular
        self.errors.add(:titular_ids, "Debe seleccionar al menos un titular") if self.titular_ids.blank?
      end
  end

  module ClassMethods
    # Define las validaciones y filtros que se deben aplicar a la clase
    def set_validations_and_filters
      validates_presence_of :tipo_marca_id, :fecha_instruccion, :instruccion, :if => :propia?
      validate :validar_agente, :if => :propia?
      validate :validar_titular, :if => :propia?
    end

  end
end
