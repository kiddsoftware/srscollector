class CardModelTemplateSerializer < ActiveModel::Serializer
  attributes :id, :name
  attributes :anki_front_template, :anki_back_template
end
