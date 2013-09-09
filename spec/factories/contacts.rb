# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    email "MyString"
    name "MyString"
    subject "MyString"
    body "MyText"
  end
end
