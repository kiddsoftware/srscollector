class MediaFile < ActiveRecord::Base
  belongs_to :card
  has_attached_file :file, styles: { original: "240x240>" }

  validates :card, presence: true
  validates_attachment :file,
    presence: true,
    content_type: { content_type: /^image\/(jpg|png|gif)$/ },
    size: { in: 0..128.kilobytes }
  validates :file_fingerprint, presence: true

  # Download our URL.
  before_validation(on: :create) do
    if url && !file.exists?
      open(URI.parse(url)) do |f|
        self.file = f
      end
    end
  end
end
