# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
# Crea una realacion polimorfica hacia la derecha
module HasManyRight
  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    # incializa los metodos necesarios para realizar has_many_right
    #   @param String
    #   @param String
    def has_many_right(klass, original_klass,  join_model, join_alias = nil)
      join_alias ||= join_model
      klass = klass.to_s.singularize
      original_klass = original_klass.to_s
      join_model = join_model.to_s
      join_alias = join_alias.to_s
      include HasManyRight::InstanceMethods

      set_has_many_right_methods(klass, original_klass ,join_model, join_alias)
    end

    # Define los metodos para una determinada instancia
    def set_has_many_right_methods(klass, original_klass, join_model, join_alias)
      # #{klass}_ids
      define_method "#{klass}_ids" do
        find_right_ids(klass, join_model, join_alias)
      end
      
      # klass.pluralize
      define_method "#{klass}_ids=" do |ids|
        ids = [] if ids.nil?
        raise "Error, you must pass an instance of array" unless ids.is_a? Array
        set_right_ids(klass, join_model, join_alias, ids)
      end

      # klass.pluralize
      define_method "#{klass.pluralize}" do
        find_right_models(klass, original_klass, join_model, join_alias)
      end

    end
  end

  module InstanceMethods
    # Busca los ids relacionados de una clase
    def find_right_ids(klass, join_model, join_alias)
      unless instance_variable_get("@#{klass}_ids".to_sym).nil?
        instance_variable_get("@#{klass}_ids".to_sym)
      else
        join_alias_id = "#{join_alias}_id".to_sym
        join_klass = join_model.classify.constantize

        instance_variable_set "@#{klass}_ids", join_klass.all(:select => "#{join_alias}_id",
            :conditions => { "#{join_alias}_type".to_sym => klass.titleize,
            "#{self.class.to_s.downcase}_id" => self.id } ).map(&join_alias_id)
      end
    end

    def init_has_many_right_instance(klass, val = nil)
      self.instance_variable_set(klass.to_sym, nil)
    end

    def get_has_many_right_instance(klass)
      self.instance_variable_get(klass.to_sym)
    end

    def set_right_ids(klass, join_model, join_alias, ids)
      ids.uniq!
      join_klass = join_model.classify.constantize
      join_alias_id = "#{join_alias}_id"
      join_alias_type = "#{join_alias}_type"
      old_ids = find_right_ids(klass, join_model, join_alias)

      join_klass.transaction do
        ids.each do |key|
          unless old_ids.include? key
            join_klass.create(
              join_alias_id => key,
              join_alias_type => klass.classify,
              "#{ self.class.to_s.downcase }_id" => self.id
            )
          else
            old_ids.delete(key)
          end
        end
        
        # Actualizacion de variable para cache
        instance_variable_set("@#{klass}_ids".to_sym, ids)
        instance_variable_set("@#{klass.pluralize}".to_sym, nil)

        unless old_ids.empty?
          old_ids.each do |key|
            join_klass.first( :conditions => { join_alias_id => key, join_alias_type => klass.classify  } ).destroy
          end
        end

      end

    end

    # Busca los modelos a la derecha
    def find_right_models(klass, original_klass, join_model, join_alias)
      #debugger if 'titular' == klass
      #unless instance_variable_get("@#{klass}".to_sym).blank?
      #  instance_variable_get("@#{klass}".to_sym)
      #else
        right_ids = find_right_ids(klass, join_model, join_alias)
        original_klass_model = original_klass.classify.constantize
        unless right_ids.empty?
          instance_variable_set "@#{klass}".to_sym, original_klass_model.find(right_ids)
        else
          []
        end
      #end
    end

  end
end
