require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ListaPublicacion do
  before(:each) do
    @path = File.join(Rails.root, 'spec', 'archivos', 'signos_sep_oct_09-12.html')
    @n = Nokogiri::HTML(File.open(@path) )

    @parse = {
      'NUMERO DE PUBLICACION' => 1,
      'NOMBRE DE LA MARCA' => -1,
      'NUMERO DE SOLICITUD' => 1,
      'CLASE INTERNACIONAL' => 1,
      'TIPO DE MARCA' => -3,
      'TIPO SIGNO' => 1
    }

  end

  it 'debe ser nokogiri' do
    @n.class.should == Nokogiri::HTML::Document 
  end

  it 'debe buscar el elemento' do
    ListaPublicacion.extraer_datos_html(@n, @parse).size.should == 3
  end
  
end
