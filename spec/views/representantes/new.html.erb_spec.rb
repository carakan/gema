require 'spec_helper'

describe "/representantes/new.html.erb" do
  include RepresentantesHelper

  before(:each) do
    assigns[:representante] = stub_model(Representante,
      :new_record? => true,
      :nombre => "value for nombre",
      :email => "value for email",
      :direccion => "value for direccion",
      :telefono => "value for telefono",
      :type => "value for type"
    )
  end

  it "renders new representante form" do
    render

    response.should have_tag("form[action=?][method=post]", representantes_path) do
      with_tag("input#representante_nombre[name=?]", "representante[nombre]")
      with_tag("input#representante_email[name=?]", "representante[email]")
      with_tag("input#representante_direccion[name=?]", "representante[direccion]")
      with_tag("input#representante_telefono[name=?]", "representante[telefono]")
      with_tag("input#representante_type[name=?]", "representante[type]")
    end
  end
end
