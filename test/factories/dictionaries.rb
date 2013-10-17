# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dictionary do
    name "My Dictionary"
    from_lang "en"
    to_lang "en"
    url_pattern "http://example.com/%s"
  end
end
