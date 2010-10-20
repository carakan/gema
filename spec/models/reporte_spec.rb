require File.dirname(__FILE__) + '/../spec_helper'

describe Reporte do
  it "should be valid" do
    Reporte.new.should be_valid
  end
end
