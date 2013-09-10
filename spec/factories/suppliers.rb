# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :test_supplier_1, class: Supplier do
    name "Test Supplier 1"
    contact_info "supplier1@example.com"
    active true
  end

end
