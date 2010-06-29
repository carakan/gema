require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ListaPublicacion do
  before(:each) do
    @pdf = File.join(SPEC_FILES, 'prueba_lista_publicacion.pdf')
    @html = File.join(SPEC_FILES, 'signos_sep_oct_09-12.html')
    @n = Nokogiri::HTML(File.open(@html) )
    ListaPublicacion.posicion = 0

    @parse = [
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

  end

  after do
    dir = File.join( SPEC_FILES, 'pdftest')
    Dir.glob("#{dir}/*"){|v| File.delete(v) unless File.extname(v) == '.pdf' }
  end

  it 'debe ser nokogiri' do
    @n.class.should == Nokogiri::HTML::Document 
  end

  it 'debe presentar error si el archivo no es pdf' do
    archivo = File.join(SPEC_FILES, 'falso_pdf.pdf')
    lambda{ ListaPublicacion.preparar_pdf(archivo) }.should raise_error
  end

  it 'debe presentar error si el direcotio a subir no existe' do
    ListaPublicacion.stub!(:pdf_path).and_return('jejejejeje1234')
    lambda{ ListaPublicacion.preparar_pdf(@pdf) }.should raise_error
  end


  it 'debe mover archivo a la ruta indicada' do
    archivo = ActionController::TestUploadedFile.new(@pdf, 'application/pdf')
    path = ListaPublicacion.preparar_pdf(archivo)
    File.exists?(path).should == true
    FileUtils.remove_dir(File.dirname(path))
  end

  it 'debe convertir el pdf' do
    archivo = File.join(SPEC_FILES, 'pdftest', 'test_pdf_upload.pdf')
    ListaPublicacion.convertir_pdf(archivo)
  end

  it 'debe buscar dato por nombre' do
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'NUMERO DE PUBLICACION', 1, true ).should == '137454'
  end

  it 'debe buscar dato por nombre' do
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'NUMERO DE PUBLICACION', 1, true )
    ListaPublicacion.posicion.should == 2
  end

  it 'debe buscar item con desplazamiento negativo' do
    ListaPublicacion.posicion = 2
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'FECHA DE SOLICITUD', -1, false ).should == '20090901'
  end

  it 'debe buscar item con desplazamiento mayor a 1' do
    ListaPublicacion.posicion = 2
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'TIPO DE MARCA', -3, false ).should == 'Marca Servicio'
  end

  it 'debe retornar falso si se busca algo que no hay en el contexto' do
    ListaPublicacion.posicion = 2
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'NO EXISTE', -3, false ).should == false
  end

  it 'debe ' do
    ListaPublicacion.posicion = 79
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'NUMERO DE PUBLICACION', 1, true ).should == false
    ListaPublicacion.posicion.should == 84
  end

  it 'debe encontrar numero de solicitud' do
    ListaPublicacion.posicion = 5
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'NUMERO DE SOLICITUD', 1, false ).should == '3432-2009'
  end


  it 'debe encontrar todos los elementos' do
    resultados = [
        ['NUMERO DE PUBLICACION' , '137454'],
        ['NOMBRE DE LA MARCA' , 'PETRONAS'],
        ['NUMERO DE SOLICITUD' , '3432-2009'],
        ['FECHA DE SOLICITUD' , '20090901'],
        ['TIPO DE SIGNO' , 'Denominación'],
        ['TIPO DE MARCA', 'Marca Servicio'],
        ['NOMBRE DEL TITULAR' , 'Petroliam Nasional Berhad (PETRONAS)'],
        ['DIRECCION DEL TITULAR' , 'Tower 1, Petronas Twin Towers Kuala Lumpur City Centre, 50088 Kuala Lumpur – Malasia'],
        ['PAIS DEL TITULAR' , 'Malasia'],
        ['NOMBRE DEL APODERADO' , 'Lorena Otero Rojas'],
        ['DIRECCION DEL APODERADO' , 'Avenida Piraí No. 2115'],
        ['PRODUCTOS' , 'Construcción de edificios; reparación; servicios de instalación; coche, mantenimiento y reparación de vehículos y remolques; lavado y limpieza de vehículos y remolques; lavado de motor de vehículo; servicios anti corrosión; alquiler de maquinaria; mantenimiento y reparación; reparación y mantenimiento de bomba; pintado y reparación de símbolos; mantenimiento, reparación y cuidado de motores de vehículos, barcos, plataformas petrolíferas, aeronaves; estaciones de gas para el suministro y llenado de combustible en vehículos.'],
        ['CLASE INTERNACIONAL' , '37']
    ]
    @parse.each_with_index do |el, i|
      k, desp = el
      primero = @parse.first[0] == k
      res = ListaPublicacion.buscar_por_nombre( @n.css('div>div'), k, desp, primero).should == resultados[i].last
    end
  end

  it 'debe buscar el elemento' do
    ListaPublicacion.extraer_datos_html(@html).size.should == 3
  end

  # No es test unitario
  it 'debe importar correctamente' do
    u = Usuario.create!(:nombre => 'Admin', :login => 'admin', :password => 'demo123' )

    UsuarioSession.current_user = u
    archivo = ActionController::TestUploadedFile.new(@pdf, 'application/pdf')
    ListaPublicacion.importar_pdf(archivo)
    Marca.all.size.should == 28
  end
  
end


