# eoncoding: utf-8
class ListaPublicacion < Marca

  validates_presence_of :tipo_marca_id, :numero_publicacion
  validates_numericality_of :numero_publicacion
  validate :existencia_anterior
  
  #####################################
  # Importacion de excel
  include PDF
  # Razon, usando un hash es desordenado
  # # Razon, usando un hash es desordenado
  @lista_pub_pdf = [
      ['NUMERO DE PUBLICACION',   1],
      ['NOMBRE DE LA MARCA',     -1],
      ['NUMERO DE SOLICITUD',     1],
      ['FECHA DE SOLICITUD',     -1],
      ['TIPO DE SIGNO',          -1],
      ['TIPO DE MARCA',          -3],
      ['NOMBRE DEL TITULAR',     -1],
      ['DIRECCION DEL TITULAR',   1],
      ['PAIS DEL TITULAR',        2],
      ['NOMBRE DEL APODERADO',    1],
      ['DIRECCION DEL APODERADO', 1],
      ['PRODUCTOS',               1],
      ['CLASE INTERNACIONAL',     1]
  ]
  acts_as_pdftohtml('archivos/temp/pdf/', 'div>div', :preparar_datos_pdf , @lista_pub_pdf)


  # Realiza la importacion de un archivo excel o un pdf
  def self.importar(archivo, gaceta = '')
    @fecha_importacion_global = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")

    self.transaction do |trans|
      case File.extname(archivo.original_filename.downcase)
        when ".pdf" 
          importar_pdf(archivo)
        when ".xls" 
          importar_excel(archivo)
      end
    end

    @fecha_importacion_global
  end


  def self.importar_excel(archivo)
  end

  def self.parsear_fecha_pdf(fec)
    begin
      "#{fec[0, 4]}-#{fec[4, 2]}-#{fec[6, 2]}"
    rescue
      nil
    end
  end

  # Debe indicarse de que no existio una marca anterior de la cual se
  # actualizo sus datos
  def self.crear_lista_publicacion(attrs)
    lista = ListaPublicacion.new(attrs.merge(:valido => false))
    # lista.valid?, en caso de que se quiera validar, pero :valido => false
    lista.save(false)
  end

  # Actualiza los datos de marca y lo cambia a lista de publicacion

  def self.actualizar_lista_publicacion(marca, attributes)
    marca.attributes = attributes
  def self.actualizar_lista_publicacion(marca, attrs)
    marca.attributes = attrs
    marca.type = 'ListaPublicacion'

    lista = ListaPublicacion.new(marca.attrs)
    # Se le asigna un numero de solicitud falso para que no ejecute
    # validates_uniqueness_of :numero_solicitud
    l.numero_solicitud = '0000-0000'
    if l.valid?
    lista.numero_solicitud = '0000-0000'
    if lista.valid?
      marca.save
    else
      marca.valido = false
      marca.save(false)
    end

  end


  # Metodo que es invocado dentro de la iteracion de datos
  # En caso de las tablas relacionadas lo que hace es 
  # llamar a su metodo set_*** para poder asignar el id de 
  # la tabla con la que se relaciona
  # @param Hash params
  def self.preparar_datos_pdf(params)
    marca = Marca.find_by_numero_solicitud(params['NUMERO DE SOLICITUD'])

    attrs = {
      :nombre => params['NOMBRE DE LA MARCA'], 
      :estado => 'lp',
      :estado_fecha => parsear_fecha_pdf(params['FECHA DE SOLICITUD']),
      :fecha_importacion => @fecha_importacion_global,
      :productos => params['PRODUCTOS'],
      :clase_id => Clase.find_by_codigo(params['CLASE INTERNACIONAL']) || 0,
      :valido => true
    }

    [:tipo_signo_id, :tipo_marca_id, :agente_id, :titular_id].each do |m|
      klass = send("set_#{m.to_s.gsub(/_id$/, '')}", params)
      attrs[m] = klass.id if klass
    end

    unless marca
      crear_lista_publicacion(attrs)
    else
      actualizar_lista_publicacion(marca, attrs)
    end
      
  end



  #################################################################
  # Metodos especiales para poder buscar o crear datos relacionados a la marca

  # Busca y actualiza o crea el titular
  def self.set_titular(params)
    return false if params['NOMBRE DEL TITULAR'].blank?

    titular = Titular.find_by_nombre(params['NOMBRE DEL TITULAR'])
    if titular
      titular.attributes = { :direccion => params['DIRECCION DEL TITULAR'], :validar => false }
    else
      titular = Titular.new(:nombre => params['NOMBRE DEL TITULAR'], :direccion => params['DIRECCION DEL TITULAR'], :validar => false)
    end
    titular.save

    titular
  end

  # Busca y actualiza o crea un agente
  def self.set_agente(params)
    return false if params['NOMBRE DEL APODERADO'].blank?

    agente = Agente.find_by_nombre(params['NOMBRE DEL APODERADO'])
    if agente
      agente.attributes = { :direccion => params['DIRECCION DEL APODERADO'], :validar => false }
    else
      agente = Agente.new(:nombre => params['NOMBRE DEL APODERADO'], :direccion => params['DIRECCION DEL TITULAR'], :validar => false)
    end
    agente.save

    agente
  end

  # Busca tipo_signo sino retorna falso
  def self.set_tipo_signo(params)
    if tipo_signo = TipoSigno.find_by_nombre(params['TIPO DE SIGNO'])
      tipo_signo
    else
      false
    end
  end

  # Busca tipo_marca sino retorna falso
  def self.set_tipo_marca(params)
    if tipo_marca = TipoMarca.find_by_nombre(params['TIPO DE MARCA'])
      tipo_marca
    else
      false
    end
  end

  # Fin de metodos relacionados a la amrca


private

  # Busca o actualiza los datos cargados a traves de la importacion
  def self.actualizar_datos(params, fecha_imp)
    #params.each do |key, val|
    #  case
    #  end
    #end
  end

  # Metodo que se usa para validar cuando se esta creando un registro que no existio
  # en un estado anterior a "lp"
  def existencia_anterior
    unless anterior
      self.errors.add(:anterior, 'No existe un registro previo')
    end
  end

end

