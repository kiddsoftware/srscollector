# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    #state "MyString"
    front "Je demande pardon"
    back ""
    source ""
    source_url ""
  end
end