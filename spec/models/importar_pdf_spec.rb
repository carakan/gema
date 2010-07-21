require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

Usuario.destroy_all
Usuario.create!(:nombre => 'Admin', :login => 'admin', :password => 'demo123', :password_confirmation => 'demo123' )
describe 'Importacion de PDF' do
  before(:each) do
    @paramas_yaml = YAML.load_file( Rails.root.to_s + '/lib/mod_marca/lista_publicacion_pdf.yml')
    @pdf_path
    class Prueba
      include ModMarca::PDF

      def self.transaction
        yield
      end
    end
    Prueba.posicion = 1
    Prueba.css_selector = 'div>div'

    UsuarioSession.current_user = Usuario.first 
  end

  after do
    ['*.html', '*.png'].each do |tipo|
      path = File.join(SPEC_FILES, "pdftest/#{tipo}")
      Dir.glob(path).each { |f|  File.delete(f) }
    end
  end

  #it 'debe poder prepara el pdf' do
  #  { ModMarca::Solicitud, ModMarca::PDF }.each { |m| Marca.send(:include, m) }
  #  Marca.preparar_importacion_pdf([])
  #end

  it 'debe buscar por nombre' do
    n = Nokogiri::HTML(File.open( File.join(SPEC_FILES, 'signos_sep_oct_09-12.html') ) ) 
    Prueba.lista_seleccionada = @paramas_yaml['DENOMINATIVAS']
    Prueba.buscar_por_nombre(n.css('div>div'), 'NUMERO DE PUBLICACION', 1, true).should == '137454'
  end

  it 'no debe encontrar nombre' do
    n = Nokogiri::HTML(File.open( File.join(SPEC_FILES, 'prueba_lista_publicacion-6.html') ) ) 
    Prueba.lista_seleccionada = @paramas_yaml['DENOMINATIVAS']
    Prueba.buscar_por_nombre(n.css('div>div'), 'NUMERO DE PUBLICACION', 1, true).should == false
  end

  it 'debe buscar seccion' do
    html = File.join(SPEC_FILES, 'prueba_lista_publicacion-6.html')
    Prueba.lista_seleccionada = @paramas_yaml['DENOMINATIVAS']
    Prueba.seccion = 'DENOMINATIVAS'
    Prueba.extraer_datos_html(html, 1)
    Prueba.seccion.should == 'FIGURATIVAS'
  end

  it 'debe importar pdf' do
    archivo = File.join( SPEC_FILES, 'pdftest/prueba_lista_publicacion.pdf')
    params = { :gaceta => '1212', :tipo => 'lp' }
    params[:archivo] = ActionController::TestUploadedFile.new(archivo, 'application/pdf') 
    Marca.importar(params)
  end

end
