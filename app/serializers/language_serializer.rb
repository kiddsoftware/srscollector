class LanguageSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :iso_639_1, :name

  # Include IDs for our dictionary models.
  has_many :dictionaries_from, root: :dictionaries
  has_many :dictionaries_to, root: :dictionaries
end

