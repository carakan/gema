module HasManyRight
  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    # incializa los metodos necesarios para realizar has_many_right
    #   @param String
    #   @param String
    def has_many_right(klass, join_model, join_alias)
      join_alias ||= join_model
      klass = klass.to_s.singularize
      join_model = join_model.to_s
      join_alias = join_alias.to_s
      include HasManyRight::InstanceMethods

      set_has_many_right_methods(klass, join_model, join_alias)
    end

    # Define los metodos para una determinada instancia
    def set_has_many_right_methods(klass, join_model, join_alias)
      define_method "#{klass}_ids" do
        find_right_ids(klass, join_model, join_alias)
      end
    end
  end

  module InstanceMethods

    def find_right_ids(klass, join_model)
      join_alias_id = "#{join_alias}_id".to_sym
      join_model.all(:select => "#{join_alias}_id",
          :conditions => { "#{join_alias}_type".to_sym => klass.titlelize,
          "#{self.class.to_s.downcase}_id".to_sym => self.id } ).map(&join_alias_id)
    end
  end
end
