# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card_model_field do
    card_model
    order 0
    name "Front"
    card_attr "front"
  end
end
