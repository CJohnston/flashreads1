require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(:title => "My Book Title",
                           :author => "Billy Bob",
                            :description => "yyy",
                            :genre => "Blackness",
                          :image_url => "zzz.jpg",
                            :file_link => "bla.zip")
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
                 product.errors[:price].join('; ')
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
                 product.errors[:price].join('; ')
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(:title => "My Book Title",
                :author => "Billy Bob",
                :description => "yyy",
                :genre => "Blackness",
                :price => 1,
                :file_link => "bla.zip",
                :image_url => image_url)

  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(:title => products(:ruby).title,
                          :author => "Billy Bob",
                          :description => "yyy",
                          :genre => "Blackness",
                          :price => 1,
                          :image_url => "fred.gif",
                          :file_link => "bla.zip")

      assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(:title => products(:ruby).title,
                          :author => "Billy Bob",
                          :description => "yyy",
                          :genre => "Blackness",
                          :price => 1,
                          :image_url => "fred.gif",
                          :file_link => "bla.zip")

    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
                 product.errors[:title].join('; ')
  end

end
