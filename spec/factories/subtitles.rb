# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subtitle do
    playable_media
    language
    start_time 0.1
    end_time 1.0
    text "Subtitle text"
  end
end
