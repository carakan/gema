# eoncoding: utf-8
class ListaPublicacion < Marca

  validates_presence_of :tipo_marca_id
  
  #####################################
  # Importacion de excel
  include PDF
  # Razon, usando un hash es desordenado
  # # Razon, usando un hash es desordenado
  @lista_pub = [
      ['NUMERO DE PUBLICACION' , 1],
      ['NOMBRE DE LA MARCA' , -1],
      ['NUMERO DE SOLICITUD' , 1],
      ['FECHA DE SOLICITUD' , -1],
      ['TIPO DE SIGNO' , -1],
      ['TIPO DE MARCA', -3],
      ['NOMBRE DEL TITULAR' , -1],
      ['DIRECCION DEL TITULAR' , 1],
      ['PAIS DEL TITULAR' , 2],
      ['NOMBRE DEL APODERADO' , 1],
      ['DIRECCION DEL APODERADO' , 1],
      ['PRODUCTOS' , 1],
      ['CLASE INTERNACIONAL' , 1]
  ]
  acts_as_pdftohtml('archivos/temp/pdf/', 'div>div', :actualizar_datos_pdf , @lista_pub)


  def self.importar(archivo, gaceta = '')
    case File.extname(archivo.original_filename.downcase)
      when ".pdf" 
        importar_pdf(archivo)
      when ".xls" 
        importar_excel(archivo)
    end
  end


  def self.importar_excel(archivo)
  end

  def self.parsear_fecha_pdf(fec)
    "#{fec[0, 4]}-#{fec[4, 2]}-#{fec[6, 2]}"
  end

  # Metodo que es invocado dentro de la iteracion de datos
  def self.actualizar_datos_pdf(params)
    marca = Marca.find_by_numero_solicitud(params['NUMERO DE SOLICITUD'])
    Agente.buscar_por_nombre_y_actualizar()

    attributes = {
      :nombre => params['NOMBRE DE LA MARCA'], 
      :estado => 'lp'
      :estado_fecha => parsear_fecha_pdf(params['FECHA DE SOLICITUD']),
      :tipo_signo_id => '',
      :tipo_marca_id => '',
      :titular_id => '',
      :agente_id => ''
    }
      
      'NUMERO DE SOLICITUD    #marca.update_attributes()
      'FECHA DE SOLICITUD'
      'TIPO DE SIGNO' , -1    #case
      'TIPO DE MARCA', -3]    #when 'NUMERO DE PUBLICACION'
    #  
    #when 'NOMBRE DE LA MARCA' , -1],
    #when 'NUMERO DE SOLICITUD' , 1],
    #when 'FECHA DE SOLICITUD' , -1],
    #when 'TIPO DE SIGNO' , -1],
    #when 'TIPO DE MARCA', -3],
    #when 'NOMBRE DEL TITULAR' , -1],
    #when 'DIRECCION DEL TITULAR' , 1],
    #when 'PAIS DEL TITULAR' , 2],
    #when 'NOMBRE DEL APODERADO' , 1],
    #when 'DIRECCION DEL APODERADO' , 1],
    #when 'PRODUCTOS' , 1],
    #when 'CLASE INTERNACIONAL' , 1]
    #end
  end



    #@campos = {
    #  'NUMERO DE PUBLICACION' => :numero_publicacion,
    #  'NOMBRE DE LA MARCA' => :nombre,
    #  'NUMERO DE  SOLICITUD' => :numero_solicitud,
    #  'FECHA DE SOLICITUD' => :fecha_solicitud,
    #  'TIPO DE SIGNO' => :tipo_signo_identidad,
    #  'TIPO DE MARCA'=> :tipo_marca_identidad,
    #  'NOMBRE DEL TITULAR' => :titular_nombre,
    #  'DIRECCION DEL TITULAR' => :titular_direccion,
    #  'PAIS DEL TITULAR' => :titular_pais,
    #  'NOMBRE DEL APODERADO' => :agente_nombre,
    #  'DIRECCION DEL APODERADO' => :agente_direccion,
    #  'PRODUCTOS' => :productos,
    #  'CLASE INTERNACIONAL' => :clase_codigo
    #}

private

  # Busca o actualiza los datos cargados a traves de la importacion
  def self.actualizar_datos(params, fecha_imp)
    #params.each do |key, val|
    #  case
    #  end
    #end
  end

end

