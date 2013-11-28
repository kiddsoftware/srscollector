# -*- coding: utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :language, aliases: [:from_language, :to_language] do
    sequence(:iso_639_1) {|n| "l#{n}" } # Breaks for 10 and up.
    sequence(:name) {|n| "Language #{n}" }
    anki_text_deck "Text"
    anki_sound_deck "Sound"

    factory :english do
      iso_639_1 "en"
      name "English"
      anki_text_deck "Reading"
      anki_sound_deck "Listening"
    end

    factory :french do
      iso_639_1 "fr"
      name "Français"
      anki_text_deck "Écrit"
      anki_sound_deck "Oral"
    end
  end
end
