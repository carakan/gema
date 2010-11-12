require 'spec_helper'

describe "/importaciones/index.html.erb" do
  include ImportacionesHelper

  before(:each) do
    assigns[:importaciones] = [
      stub_model(Importacion,
        :completa => false
      ),
      stub_model(Importacion,
        :completa => false
      )
    ]
  end

  it "renders a list of importaciones" do
    render
    response.should have_tag("tr>td", false.to_s, 2)
  end
end
