require 'spec_helper'

describe "/usuarios/edit.html.erb" do
  include UsuariosHelper

  before(:each) do
    assigns[:usuario] = @usuario = stub_model(Usuario,
      :new_record? => false,
      :nombre => "value for nombre",
      :rol => "value for rol",
      :login => "value for login",
      :password => "value for password"
    )
  end

  it "renders the edit usuario form" do
    render

    response.should have_tag("form[action=#{usuario_path(@usuario)}][method=post]") do
      with_tag('input#usuario_nombre[name=?]', "usuario[nombre]")
      with_tag('input#usuario_rol[name=?]', "usuario[rol]")
      with_tag('input#usuario_login[name=?]', "usuario[login]")
      with_tag('input#usuario_password[name=?]', "usuario[password]")
    end
  end
end
