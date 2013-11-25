class DictionarySerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :name, :url_pattern, :score

  # Sideload our language models.
  has_one :from_language, root: :languages
  has_one :to_language, root: :languages
end
