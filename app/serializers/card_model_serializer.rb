class CardModelSerializer < ActiveModel::Serializer
  attributes :id, :short_name, :name
  attributes :anki_front_template, :anki_back_template, :anki_css
  has_many :card_model_fields
end
