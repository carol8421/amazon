# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'
FactoryGirl.define do
  factory :author do
    firstname "John"
    lastname "Tolkien"
    biography Faker::Lorem.sentence
    photo nil
  end
end
