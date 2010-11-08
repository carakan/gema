require 'spec_helper'

describe "/usuarios/show.html.erb" do
  include UsuariosHelper
  before(:each) do
    assigns[:usuario] = @usuario = stub_model(Usuario,
      :nombre => "value for nombre",
      :rol => "value for rol",
      :login => "value for login",
      :password => "value for password"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ nombre/)
    response.should have_text(/value\ for\ rol/)
    response.should have_text(/value\ for\ login/)
    response.should have_text(/value\ for\ password/)
  end
end
