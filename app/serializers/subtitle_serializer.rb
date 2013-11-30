class SubtitleSerializer < ActiveModel::Serializer
  attributes(:id, :start_time, :end_time, :text)
  has_one :playable_media, embed: :id
  has_one :language, embed: :id
end
