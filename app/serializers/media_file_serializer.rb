class MediaFileSerializer < ActiveModel::Serializer
  attributes :id, :url, :export_filename, :download_url

  # The URL from which to download this file.
  def download_url
    object.file.url
  end
end
