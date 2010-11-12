require 'spec_helper'

describe "/usuarios/index.html.erb" do
  include UsuariosHelper

  before(:each) do
    assigns[:usuarios] = [
      stub_model(Usuario,
        :nombre => "value for nombre",
        :rol => "value for rol",
        :login => "value for login",
        :password => "value for password"
      ),
      stub_model(Usuario,
        :nombre => "value for nombre",
        :rol => "value for rol",
        :login => "value for login",
        :password => "value for password"
      )
    ]
  end

  it "renders a list of usuarios" do
    render
    response.should have_tag("tr>td", "value for nombre".to_s, 2)
    response.should have_tag("tr>td", "value for rol".to_s, 2)
    response.should have_tag("tr>td", "value for login".to_s, 2)
    response.should have_tag("tr>td", "value for password".to_s, 2)
  end
end
