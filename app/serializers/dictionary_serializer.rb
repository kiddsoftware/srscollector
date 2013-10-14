class DictionarySerializer < ActiveModel::Serializer
  attributes :id, :name, :from_lang, :to_lang, :url_pattern, :score
end
