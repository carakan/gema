require 'spec_helper'

describe "/representantes/show.html.erb" do
  include RepresentantesHelper
  before(:each) do
    assigns[:representante] = @representante = stub_model(Representante,
      :nombre => "value for nombre",
      :email => "value for email",
      :direccion => "value for direccion",
      :telefono => "value for telefono",
      :type => "value for type"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ nombre/)
    response.should have_text(/value\ for\ email/)
    response.should have_text(/value\ for\ direccion/)
    response.should have_text(/value\ for\ telefono/)
    response.should have_text(/value\ for\ type/)
  end
end
