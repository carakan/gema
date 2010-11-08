require 'spec_helper'

describe TipoMarca do
  before(:each) do
    @valid_attributes = {
      :nombre => "value for nombre",
      :descripcion => "value for descripcion"
    }
  end

  it "should create a new instance given valid attributes" do
    TipoMarca.create!(@valid_attributes)
  end
end
