require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Importacion de PDF' do
  before(:each) do
    @paramas_yaml = YAML.load_file( Rails.root.to_s + '/lib/mod_marca/lista_publicacion_pdf.yml')
    @pdf_path
    class Prueba
      include ModMarca::PDF
    end
    Prueba.posicion = 1
    Prueba.css_selector = 'div>div'
  end

  after do
    ['*.html', '*.png'].each do |tipo|
      Dir.glob(File.join(Rails.root, 'spec/archivos/pdftest/#{tipo}') ).each { |f| File.delete(f) }
    end
  end

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
    Prueba.extraer_datos_html(html)
    Prueba.seccion.should == 'FIGURATIVAS'
  end

end
