require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
#require 'spec_helper'

describe Marca do
  before(:each) do
    @params = { :nombre => 'Especial', :fecha_solicitud => '2009-10-11', 
      :estado => 'sm', :tipo_marca_id => 2, :numero_solicitud => '02323-2009' }
    @marca = Marca.create!(@params)
  end


  it 'should show estado' do
    Marca::TIPOS.each do |k, v|
      marca = Marca.new(:estado => k)
      marca.ver_estado.should == v
    end
  end

  it 'should show estado for instance' do
    Marca::TIPOS.each do |k, v|
      Marca::ver_estado(k).should == v
    end
  end

  it 'Should each marca have item cobros' do

    @marca.item_cobros.should have(0).items
  end
end

