require 'test_helper'

class ReporteMarcasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reporte_marcas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reporte_marca" do
    assert_difference('ReporteMarca.count') do
      post :create, :reporte_marca => { }
    end

    assert_redirected_to reporte_marca_path(assigns(:reporte_marca))
  end

  test "should show reporte_marca" do
    get :show, :id => reporte_marcas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => reporte_marcas(:one).to_param
    assert_response :success
  end

  test "should update reporte_marca" do
    put :update, :id => reporte_marcas(:one).to_param, :reporte_marca => { }
    assert_redirected_to reporte_marca_path(assigns(:reporte_marca))
  end

  test "should destroy reporte_marca" do
    assert_difference('ReporteMarca.count', -1) do
      delete :destroy, :id => reporte_marcas(:one).to_param
    end

    assert_redirected_to reporte_marcas_path
  end
end
