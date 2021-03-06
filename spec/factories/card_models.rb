# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card_model do
    sequence(:short_name) {|n| "model#{n}" }
    sequence(:name) {|n| "Model #{n}" }
    anki_css ".card {}"
  end
end

# Find or build our singleton card model.
def default_card_model_for_spec
  model = CardModel.where(short_name: "basic").first
  unless model
    attrs = FactoryGirl.attributes_for(:card_model, name: "SRS Collector Basic",
                                       short_name: "basic")
    model = create_default_card_model_from_attrs(attrs)
  end
  model
end

# Find or build our cloze card model.
def default_cloze_card_model_for_spec
  model = CardModel.where(short_name: "cloze").first
  unless model
    attrs = FactoryGirl.attributes_for(:card_model, name: "SRS Collector Cloze",
                                       short_name: "cloze", cloze: true)
    model = create_default_card_model_from_attrs(attrs)
  end
  model
end

def create_default_card_model_from_attrs(attrs)
  model = CardModel.create!(attrs)
  CardModelField.create!(card_model: model, order: 0, name: "Front",
                         card_attr: 'front')
  CardModelField.create!(card_model: model, order: 1, name: "Back",
                         card_attr: 'back')
  CardModelField.create!(card_model: model, order: 2, name: "Source",
                         card_attr: 'source_html')  
  FactoryGirl.create(:card_model_template, card_model: model)
  model.reload
  model
end
