require 'spec_helper'

describe "/testes/new.html.erb" do
  include TestesHelper

  before(:each) do
    assigns[:test] = stub_model(Test,
      :new_record? => true
    )
  end

  it "renders new test form" do
    render

    response.should have_tag("form[action=?][method=post]", testes_path) do
    end
  end
end
