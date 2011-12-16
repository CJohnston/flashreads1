require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @update = {
        :title => 'My Book',
        :author => 'Daddy Christmas',
        :description => 'Exams are great!',
        :genre => 'Crackers',
        :image_url => 'mybook.jpg',
        :price => 19.95,
        :file_link => 'hello.zip'
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, :product => @update
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, :id => @product.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product.to_param
    assert_response :success
  end

  test "should update product" do
    put :update, :id => @product.to_param, :product => @update
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, :id => @product.to_param
    end

    assert_redirected_to products_path
  end
end
