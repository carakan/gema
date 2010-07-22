require 'spec_helper'

describe ImportacionesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/importaciones" }.should route_to(:controller => "importaciones", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/importaciones/new" }.should route_to(:controller => "importaciones", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/importaciones/1" }.should route_to(:controller => "importaciones", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/importaciones/1/edit" }.should route_to(:controller => "importaciones", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/importaciones" }.should route_to(:controller => "importaciones", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/importaciones/1" }.should route_to(:controller => "importaciones", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/importaciones/1" }.should route_to(:controller => "importaciones", :action => "destroy", :id => "1") 
    end
  end
end
