require 'spec_helper'

describe "/representantes/index.html.erb" do
  include RepresentantesHelper

  before(:each) do
    assigns[:representantes] = [
      stub_model(Representante,
        :nombre => "value for nombre",
        :email => "value for email",
        :direccion => "value for direccion",
        :telefono => "value for telefono",
        :type => "value for type"
      ),
      stub_model(Representante,
        :nombre => "value for nombre",
        :email => "value for email",
        :direccion => "value for direccion",
        :telefono => "value for telefono",
        :type => "value for type"
      )
    ]
  end

  it "renders a list of representantes" do
    render
    response.should have_tag("tr>td", "value for nombre".to_s, 2)
    response.should have_tag("tr>td", "value for email".to_s, 2)
    response.should have_tag("tr>td", "value for direccion".to_s, 2)
    response.should have_tag("tr>td", "value for telefono".to_s, 2)
    response.should have_tag("tr>td", "value for type".to_s, 2)
  end
end
