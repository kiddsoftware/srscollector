# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    user
    card_model { default_card_model_for_spec }
    front "Je demande pardon"

    factory :new_card do
      state "new" # Already the default, but make it explicit.
    end

    factory :reviewed_card do
      language
      state "reviewed"
    end
  end
end
