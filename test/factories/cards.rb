# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    user
    card_model { default_card_model_for_spec }
    #state "new"
    front "Je demande pardon"
    back ""
    source ""
    source_url ""
  end
end
