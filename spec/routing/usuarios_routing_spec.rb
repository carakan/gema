require 'spec_helper'

describe UsuariosController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/usuarios" }.should route_to(:controller => "usuarios", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/usuarios/new" }.should route_to(:controller => "usuarios", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/usuarios/1" }.should route_to(:controller => "usuarios", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/usuarios/1/edit" }.should route_to(:controller => "usuarios", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/usuarios" }.should route_to(:controller => "usuarios", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/usuarios/1" }.should route_to(:controller => "usuarios", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/usuarios/1" }.should route_to(:controller => "usuarios", :action => "destroy", :id => "1") 
    end
  end
end
