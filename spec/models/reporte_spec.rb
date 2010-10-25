require 'spec_helper'

describe Reporte do
  before(:each) do
    @reporte = Reporte.new(:texto_es =>"hola a atodos **hola** a todos los lque esta **veamos** hola a atodos **veam**")
    I18n.locale = :es
  end

  it "should extract params" do
    variables = @reporte.generate_variables
    @reporte.variables.size.should == 3
    @reporte.variables[0].should == "hola"
    @reporte.variables[1].should == "veamos"
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
    @reporte.generate_report().should == "hola a atodos **hola** a todos los lque esta **veamos** hola a atodos **veam**"
  end
end
