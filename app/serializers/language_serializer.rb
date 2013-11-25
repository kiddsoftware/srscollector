class LanguageSerializer < ActiveModel::Serializer
  attributes :id, :iso_639_1, :name
end

