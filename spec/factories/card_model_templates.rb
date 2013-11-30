# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card_model_template do
    name "Card 1"
    order 0
    anki_front_template "{{Front}}"
    anki_back_template "{{FrontSide}}<hr>{{Back}}"
  end
end
