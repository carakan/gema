require 'spec_helper'

describe TipoMarcasController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/tipo_marcas" }.should route_to(:controller => "tipo_marcas", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/tipo_marcas/new" }.should route_to(:controller => "tipo_marcas", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/tipo_marcas/1" }.should route_to(:controller => "tipo_marcas", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/tipo_marcas/1/edit" }.should route_to(:controller => "tipo_marcas", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/tipo_marcas" }.should route_to(:controller => "tipo_marcas", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/tipo_marcas/1" }.should route_to(:controller => "tipo_marcas", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/tipo_marcas/1" }.should route_to(:controller => "tipo_marcas", :action => "destroy", :id => "1") 
    end
  end
end
