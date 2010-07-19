require 'test_helper'

class AdjuntosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:adjuntos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create adjunto" do
    assert_difference('Adjunto.count') do
      post :create, :adjunto => { }
    end

    assert_redirected_to adjunto_path(assigns(:adjunto))
  end

  test "should show adjunto" do
    get :show, :id => adjuntos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => adjuntos(:one).to_param
    assert_response :success
  end

  test "should update adjunto" do
    put :update, :id => adjuntos(:one).to_param, :adjunto => { }
    assert_redirected_to adjunto_path(assigns(:adjunto))
  end

  test "should destroy adjunto" do
    assert_difference('Adjunto.count', -1) do
      delete :destroy, :id => adjuntos(:one).to_param
    end

    assert_redirected_to adjuntos_path
  end
end
