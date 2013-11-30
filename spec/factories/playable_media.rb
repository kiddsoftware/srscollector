# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :playable_media do
    user { FactoryGirl.create(:supporter) }
    language
    kind "video"
    url "http://www.example.com/vid.mp4"
  end
end
