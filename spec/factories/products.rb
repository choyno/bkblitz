# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :test_product_1, class: Product do
    name "Test Product 1"
    wholesale_price "50.00"
    retail_price "100.00"
    description "This is the description of test product 1"
    association :supplier, factory: :test_supplier_1
  end

end
