require 'spec_helper'

describe TestesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/testes" }.should route_to(:controller => "testes", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/testes/new" }.should route_to(:controller => "testes", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/testes/1" }.should route_to(:controller => "testes", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/testes/1/edit" }.should route_to(:controller => "testes", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/testes" }.should route_to(:controller => "testes", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/testes/1" }.should route_to(:controller => "testes", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/testes/1" }.should route_to(:controller => "testes", :action => "destroy", :id => "1") 
    end
  end
end
