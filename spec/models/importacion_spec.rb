require 'spec_helper'

describe Importacion do
  before(:each) do
    @valid_attributes = {
      :completa => false
    }
  end

  it "should create a new instance given valid attributes" do
    Importacion.create!(@valid_attributes)
  end
end
