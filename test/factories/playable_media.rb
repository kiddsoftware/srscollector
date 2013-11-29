# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :playable_medium, :class => 'PlayableMedia' do
    user nil
    type ""
    url "MyText"
  end
end
