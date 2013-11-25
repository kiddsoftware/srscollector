# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :language, aliases: [:from_language, :to_language] do
    sequence(:iso_639_1) {|n| "l#{n}" } # Breaks for 10 and up.
    sequence(:name) {|n| "Language #{n}" }
    anki_text_deck "Text"
    anki_sound_deck "Sound"
  end
end
