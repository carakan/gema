# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format 
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /^([a-z_]+)([^aeiou])$/i, '\1\2es'
  inflect.singular /^([a-z_]+)(es)$/, '\1'
  inflect.irregular 'clase', 'clases'
  inflect.irregular 'representante', 'representantes'
  inflect.irregular 'agente', 'agentes'
  inflect.irregular 'post', 'posts'
  inflect.irregular 'marca_representante', 'marcas_representantes'
  inflect.irregular 'reporte', 'reportes'
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#  inflect.plural 'importar', 'importar' 
#   inflect.uncountable %w( fish sheep )
end
