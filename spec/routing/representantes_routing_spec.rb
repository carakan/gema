require 'spec_helper'

describe RepresentantesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/representantes" }.should route_to(:controller => "representantes", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/representantes/new" }.should route_to(:controller => "representantes", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/representantes/1" }.should route_to(:controller => "representantes", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/representantes/1/edit" }.should route_to(:controller => "representantes", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/representantes" }.should route_to(:controller => "representantes", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/representantes/1" }.should route_to(:controller => "representantes", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/representantes/1" }.should route_to(:controller => "representantes", :action => "destroy", :id => "1") 
    end
  end
end
