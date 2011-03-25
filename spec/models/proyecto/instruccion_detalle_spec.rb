require File.dirname(__FILE__) + '/../spec_helper'

describe Proyecto::InstruccionDetalle do
  it "should be valid" do
    Proyecto::InstruccionDetalle.new.should be_valid
  end
end
