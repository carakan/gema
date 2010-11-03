require 'spec_helper'

describe Reporte do
  before(:each) do
    @reporte = Reporte.new(:texto_es =>"hola a atodos **holaBola** a todos los lque esta **veamos_b** hola a atodos **veam**")

    @report =  Reporte.new(:texto_es =>"  **encabezado** La Paz xxxxxxx **tabla** blabla", :nombre_clase => "ReporteMarca")
    I18n.locale = :es
  end

  it "should extract params" do
    variables = @reporte.generate_variables
    @reporte.variables.size.should == 3
    @reporte.variables[0].should == "holaBola"
    @reporte.variables[1].should == "veamos_b"
    @reporte.variables[2].should == "veam"
  end

  it "should extract text" do
    @reporte.extract_text
    @reporte.texts.size.should == 3
    @reporte.texts[0].should == "hola a atodos "
    @reporte.texts[1].should ==" a todos los lque esta "
    @reporte.texts[2].should == " hola a atodos "
  end

  it "should generate the reports" do
    @reporte.generate_report().should == "hola a atodos **holaBola** a todos los lque esta **veamos_b** hola a atodos **veam**"
  end


end
