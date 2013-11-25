# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :language do
    iso_639_1 "MyString"
    name "MyString"
    anki_text_deck "MyString"
    anki_sound_deck "MyString"
  end
end
