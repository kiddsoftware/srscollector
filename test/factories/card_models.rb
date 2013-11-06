# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card_model do
    sequence(:short_name) {|n| "model#{n}" }
    sequence(:name) {|n| "Model #{n}" }
    anki_front_template "{{Front}}"
    anki_back_template "{{FrontSide}}<hr>{{Back}}"
    anki_css ".card {}"

    factory :card_model_with_fields do
      after(:create) do |card_model, evaluator|
        if CardModelField.where(card_model: card_model).count == 0
          FactoryGirl.create(:card_model_field, card_model: card_model,
                             order: 0, name: "Front", card_attr: 'front')
          FactoryGirl.create(:card_model_field, card_model: card_model,
                             order: 1, name: "Back", card_attr: 'back')
          FactoryGirl.create(:card_model_field, card_model: card_model,
                             order: 2, name: "Source", card_attr: 'source_html')
        end
      end

      factory :default_card_model do
        short_name "basic"
        name "SRS Collector Basic"
        # Shared by most generated cards. See
        # http://stackoverflow.com/questions/4317848
        initialize_with do
          CardModel.where(short_name: 'basic').first_or_initialize
        end
      end
    end
  end
end
