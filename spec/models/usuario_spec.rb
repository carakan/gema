require 'spec_helper'

describe Usuario do
  before(:each) do
    @valid_attributes = {
      :nombre => "value for nombre",
      :rol => "value for rol",
      :login => "value for login",
      :password => "value for password"
    }
  end

  it "should create a new instance given valid attributes" do
    Usuario.create!(@valid_attributes)
  end
end
