require 'spec_helper'

describe "/testes/index.html.erb" do
  include TestesHelper

  before(:each) do
    assigns[:testes] = [
      stub_model(Test),
      stub_model(Test)
    ]
  end

  it "renders a list of testes" do
    render
  end
end
