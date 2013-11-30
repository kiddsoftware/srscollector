class PlayableMediaSerializer < ActiveModel::Serializer
  attributes(:id, :kind, :url)
  has_one :language, embed: :id
end
