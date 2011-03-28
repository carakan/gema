require File.dirname(__FILE__) + '/../spec_helper'

describe Proyecto::Area do
  it "should be valid" do
    Proyecto::Area.new.should be_valid
  end
end
