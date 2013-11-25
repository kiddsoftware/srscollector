class DictionarySerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :name, :url_pattern, :score

  # Include IDs for our language models.
  has_one :from_language, root: :languages
  has_one :to_language, root: :languages
end
