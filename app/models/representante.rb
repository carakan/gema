# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Representante < ActiveRecord::Base
  #before_validation :set_validar
  #before_save :strip_data
  before_save :set_pais, :if => lambda{ |rep| rep.pais_id? }

  #has_and_belongs_to_many :agentes, :class_name => 'Representante',
  #  :association_foreign_key => :agente_id,
  #  :join_table => 'marcas_agentes'
  #has_and_belongs_to_many :titulares, :class_name => 'Representante',
  #  :association_foreign_key => :titular_id,
  #  :join_table => 'marcas_titulares'

  belongs_to :pais
  
  #has_many :posts, :order => 'created_at DESC'
  has_many :posts, :as => :postable, :dependent => :destroy
  has_many :reporte_marcas
  has_many :contactos
  has_many :consultas

  POSTS_SIZE = 2

  validates_presence_of :nombre
  validates :email, :presence => {:if => :cliente?}, :email => {:if => lambda { |c| !c.email.blank? } }
  validates_presence_of :telefono, :direccion, :fax, :if => :cliente?

  scope :order, order( "nombre ASC" )
  scope :lista, select("id, nombre, pais_codigo").order("nombre ASC")
  scope :clientes, where(:cliente => true)

  attr_accessor :validar

  def to_s
    %Q( #{ nombre } - ( #{ pais_codigo } ) )
  end

  # Retorna todos los titulares de las marcas seleccionadas
  def self.titular_ids(marca_ids = [])
    find_by_sql( ["SELECT titular_id FROM marcas_titulares WHERE marca_id IN (?)", marca_ids ] ).map(&:titular_id).uniq
  end

  def self.agente_ids(marca_ids = [])
    find_by_sql( ["SELECT agente_id FROM marcas_agentes WHERE marca_id IN (?)", marca_ids ] ).map(&:agente_id).uniq
  end

  def ultimos_posts()
    Post.all(:conditions => { :postable_id => self.id, :postable_type => 'Representante' }, 
      :limit => POSTS_SIZE, :order => 'created_at DESC' )
  end
  
  def lista_contactos()
    Contacto.all(:conditions => { :representante_id => self.id }, 
      :limit => POSTS_SIZE, :order => 'created_at DESC' )
  end

  # concatena los datos denormalizados de pais
  def pais_datos
    %Q(#{pais_codigo} - #{pais_nombre})
  end

  # Retorna un Hash con la lista de representantes todos los representantes "clientes" buscando en las marcas
  #   @param Array
  #   @param Symbol => [ :agentes, :titulares ]
  #   @return Array
  def self.marcas_representantes(marca_ids, tipo )
    singular_id = "#{tipo.to_s.singularize}_id"
    marcas_representantes = Representante.find_by_sql( ["SELECT * FROM marcas_#{tipo.to_s} WHERE marca_id IN (?)", marca_ids] )
    Representante.all(:conditions => { :id => marcas_representantes.map(&singular_id.to_sym).uniq } )
  end

  # Busca en un array los representantes segun los ids 
  def self.buscar_representantes(representante_ids, representantes)
    @reps ||= representantes.inject({}) { |h,v| h[v.id] = v; h }
    representante_ids.map { |v| @reps[v] }
  end

  # Listado de clientes para opciones
  def self.lista_clientes
    clientes.map { |v| [v.nombre, v.id] }
  end

  private
  # Prepara el atributo validar
  def set_validar
    self.validar = true if validar.nil?
  end

  # Denormaliza los datos de país
  def set_pais
    if self.pais
      self.pais_codigo = self.pais.codigo
      self.pais_nombre = self.pais.nombre
    end
  end

  #def strip_data
  #  [:nombre, :email, :direccion, :telefono, :movil].each do |v|
  #    self.send("#{v}=", send(v).strip) unless self.send(v).nil?
  #  end
  #end

end
