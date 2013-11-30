class PlayableMediaSerializer < ActiveModel::Serializer
  attributes(:id, :kind, :url, :links)
  has_one :language, embed: :id

  def links
    { subtitles: "/api/v1/playable_media/#{object.id}/subtitles" }
  end
end
