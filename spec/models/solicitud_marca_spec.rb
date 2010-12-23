require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
#require 'spec_helper'

describe SolicitudMarca do
  before(:each) do
    @params = { :nombre => 'Especial', :fecha_solicitud => '2009-10-11', 
      :estado => 'sm', :tipo_marca_id => 2, :numero_solicitud => '02323-2009' }
    @path = File.join(Rails.root, 'spec', 'archivos')
  end

  it 'should create valid SolicitudMarca' do
    SolicitudMarca.create!(@params)
  end

  it 'it should validate' do
    @params[:numero_solicitud] = '1212-09'
    sol = SolicitudMarca.new(@params)
    sol.valid?.should == false
    sol.errors[:numero_solicitud].should_not == nil
  end

  #it 'should raise error' do
  #  path = File.join(@path, 'test_solicitud_registro.xls')
  #  ActionController::TestUploadedFile.new(path, 'application/vnd.ms-excel')
  #end

  it 'should import' do
    path = File.join(@path, 'test_solicitud_registro.xls')
    archivo = ActionController::TestUploadedFile.new(path, 'application/vnd.ms-excel')
    sol = SolicitudMarca.import(archivo)
  end

  # Chapi test
  #it 'test raise' do
  #  lambda{ SolicitudMarca.er }.should raise_error
  #end

end
