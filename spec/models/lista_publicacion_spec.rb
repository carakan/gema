require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ListaPublicacion do
  before(:each) do
    @pdf = File.join(SPEC_FILES, 'test_pdf_upload.pdf')
    @html = File.join(SPEC_FILES, 'signos_sep_oct_09-12.html')
    @n = Nokogiri::HTML(File.open(@html) )

    @parse = {
      'NUMERO DE PUBLICACION' => 1,
      'NOMBRE DE LA MARCA' => -1,
      'NUMERO DE  SOLICITUD' => 1,
      'FECHA DE SOLICITUD' => -1,
      'TIPO DE SIGNO' => -1,
      'TIPO DE MARCA'=> -3,
      'NOMBRE DEL TITULAR' => -1,
      'DIRECCION DEL TITULAR' => 1,
      'PAIS DEL TITULAR' => 2,
      'NOMBRE DEL APODERADO' => 1,
      'DIRECCION DEL APODERADO' => 1,
      'PRODUCTOS' => 1,
      'CLASE INTERNACIONAL' => 1
    }

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
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'NUMERO DE PUBLICACION', 1 ).should == '137454'
  end

  it 'debe buscar dato por nombre' do
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'NUMERO DE PUBLICACION', 1 )
    ListaPublicacion.posicion.should == 1
  end

  it 'debe buscar item con desplazamiento negativo' do
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'FECHA DE SOLICITUD', -1 ).should == '20090901'
  end
  it 'debe buscar item con desplazamiento mayor a 1' do
    ListaPublicacion.buscar_por_nombre( @n.css('div>div'), 'TIPO DE MARCA', -3 ).should == 'Marca Servicio'
  end

  it 'debe extraer 3 datos' do
    ListaPublicacion.extraer_datos_html(@html).size.should == 3

  end

  #it 'debe buscar el elemento' do
  #  ListaPublicacion.extraer_datos_html(@n, @parse).size.should == 3
  #end
  
end


