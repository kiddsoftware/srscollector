# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subtitle do
    playable_media nil
    language nil
    start_time ""
    end_time ""
    text "MyText"
  end
end
