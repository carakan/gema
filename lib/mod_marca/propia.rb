module ModMarca
  module Propia
    def self.included(base)
      #base.send(:include, InstanceMethods)
      base.send(:extend, ClassMethods)
      base.extra_validaciones_propia
    end

    module ClassMethods
      # Define las validaciones y filtros que se deben aplicar a la clase
      def set_validations_and_filters
      end
    end

  end
end
