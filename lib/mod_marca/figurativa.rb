module ModMarca::Figurativa

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
    base.set_validations_and_filters
  end

  module InstanceMethods
  end

  module ClassMethods
    # Define las validaciones y filtros que se deben aplicar a la clase
    def set_validations_and_filters
      # relaciones
      has_one :adjunto, :as => :adjuntable
    end

end

