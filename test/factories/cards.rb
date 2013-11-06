# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    user
    association :card_model, factory: :default_card_model

    #state "new"
    front "Je demande pardon"
    back ""
    source ""
    source_url ""
  end
end
