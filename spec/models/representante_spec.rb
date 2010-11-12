require 'spec_helper'

describe Representante do
  before(:each) do
    @valid_attributes = {
      :nombre => "value for nombre",
      :email => "value for email",
      :direccion => "value for direccion",
      :telefono => "value for telefono",
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    Representante.create!(@valid_attributes)
  end
end
